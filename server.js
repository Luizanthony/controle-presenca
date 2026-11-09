require('dotenv').config();
const express = require('express');
const sql = require('mssql/msnodesqlv8');

const app = express();
app.use(express.json());
app.use(express.static('public'));

const pool = sql.connect({
  connectionString:
    'Driver={ODBC Driver 18 for SQL Server};' +
    'Server=' + (process.env.DB_SERVER || 'localhost\\SQLEXPRESS') + ';' +
    'Database=' + (process.env.DB_NAME || 'CursoEscola') + ';' +
    'Trusted_Connection=Yes;TrustServerCertificate=Yes;'
});

async function run(res, text, params = {}) {
  try {
    const r = (await pool).request();
    for (const k in params) r.input(k, params[k]);
    const out = await r.query(text);
    res.json(out.recordset || { ok: true });
  } catch (e) { res.status(500).json({ erro: e.message.replace(/^(\[[^\]]*\])+/, '') }); }
}

// entidade -> tabela, campos permitidos no cadastro, consulta de listagem
const T = {
  alunos: { table: 'Aluno', f: ['Nome', 'Email', 'Turma', 'Serie'],
    sel: 'SELECT * FROM Aluno ORDER BY Nome' },
  professores: { table: 'Professor', f: ['Nome', 'CPF', 'Email', 'AreaDeAtuacao'],
    sel: 'SELECT * FROM Professor ORDER BY Nome' },
  minicursos: { table: 'Minicurso', f: ['Nome', 'Descricao', 'DataInicio', 'DataTermino', 'CargaHoraria', 'CodProfessor'],
    sel: 'SELECT m.*, p.Nome Professor FROM Minicurso m JOIN Professor p ON p.CodProfessor = m.CodProfessor ORDER BY m.Nome' },
  matriculas: { table: 'Matricula', f: ['CodAluno', 'CodMiniCurso'],
    sel: `SELECT x.CodMatricula, a.Nome Aluno, m.Nome Minicurso, x.DataMatricula FROM Matricula x
          JOIN Aluno a ON a.CodAluno = x.CodAluno JOIN Minicurso m ON m.CodMiniCurso = x.CodMiniCurso ORDER BY x.CodMatricula DESC` },
  aulas: { table: 'Aula', f: ['DataAula', 'HorarioDeInicio', 'HorarioTermino', 'Conteudo', 'CodMiniCurso'],
    sel: `SELECT a.CodAula, m.Nome Minicurso, a.DataAula, a.HorarioDeInicio, a.HorarioTermino, a.Conteudo, a.ChamadaConcluida
          FROM Aula a JOIN Minicurso m ON m.CodMiniCurso = a.CodMiniCurso ORDER BY a.DataAula DESC` },
  turmas: { table: 'Turma', f: ['Nome'],
    sel: 'SELECT * FROM Turma ORDER BY Nome' }
};

// Cadastro de aluno passa pela procedure, que verifica a turma antes de salvar.
// Fica antes do laço abaixo para o Express usar esta rota no lugar do INSERT genérico.
app.post('/api/alunos', (req, res) => {
  const p = {};
  ['Nome', 'Email', 'Turma', 'Serie'].forEach(c => p[c] = req.body[c] === '' ? null : req.body[c]);
  run(res, 'EXEC sp_CadastrarAlunoNaTurma @Nome, @Email, @Turma, @Serie', p);
});

for (const [rota, t] of Object.entries(T)) {
  app.get('/api/' + rota, (req, res) => run(res, t.sel));
  app.post('/api/' + rota, (req, res) => {
    const p = {};
    t.f.forEach(c => p[c] = req.body[c] === '' ? null : req.body[c]);
    run(res, `INSERT INTO ${t.table} (${t.f.join(',')}) VALUES (${t.f.map(c => '@' + c).join(',')})`, p);
  });
}

// Chamada
app.get('/api/chamada/:aula', (req, res) => run(res,
  `SELECT p.CodPresenca, a.Nome, p.Situacao FROM ControleDePresenca p
   JOIN Aluno a ON a.CodAluno = p.CodAluno WHERE p.CodAula = @aula ORDER BY a.Nome`,
  { aula: req.params.aula }));

app.put('/api/presenca/:id', (req, res) => run(res,
  'UPDATE ControleDePresenca SET Situacao = @s, Horario = GETDATE() WHERE CodPresenca = @id',
  { s: req.body.situacao === 'Presente' ? 'Presente' : 'Ausente', id: req.params.id }));

// Concluir chamada: a partir daqui a aula conta para faltas e frequencia
app.put('/api/aulas/:id/concluir', (req, res) => run(res,
  'UPDATE Aula SET ChamadaConcluida = 1 WHERE CodAula = @id',
  { id: req.params.id }));

// Turmas: mudar a turma do aluno (o trigger 1 grava o historico)
app.put('/api/alunos/:id/turma', (req, res) => run(res,
  `IF NOT EXISTS (SELECT 1 FROM Turma WHERE Nome = @turma)
   BEGIN
     THROW 50001, N'Turma não encontrada.', 1;
   END;
   UPDATE Aluno SET Turma = @turma WHERE CodAluno = @id;`,
  { id: req.params.id, turma: req.body.turma }));

app.get('/api/historico-turma', (req, res) => run(res,
  `SELECT h.DataMudanca, a.Nome Aluno, h.TurmaAnterior, h.TurmaNova
   FROM HistoricoTurma h JOIN Aluno a ON a.CodAluno = h.CodAluno
   ORDER BY h.DataMudanca DESC`));

// Relatorios: view 1 e function 1
app.get('/api/relatorios/sem-presenca', (req, res) => run(res,
  'SELECT * FROM vw_AlunosSemPresenca ORDER BY Nome'));

app.get('/api/relatorios/sequencia-faltas', (req, res) => run(res,
  `SELECT Nome, Turma, dbo.fn_MaiorSequenciaFaltas(CodAluno) AS MaiorSequenciaFaltas
   FROM Aluno ORDER BY MaiorSequenciaFaltas DESC, Nome`));

// Certificados: view 2, procedure 2, function 2 e trigger 2
app.get('/api/certificados', (req, res) => run(res,
  'SELECT * FROM vw_CertificadosEmitidos ORDER BY DataEmissao DESC'));

app.post('/api/certificados', (req, res) => run(res,
  'EXEC sp_EmitirCertificado @aluno, @curso',
  { aluno: req.body.CodAluno, curso: req.body.CodMiniCurso }));

app.get('/api/certificados/validar/:codigo', (req, res) => run(res,
  'SELECT dbo.fn_ValidarCertificado(@codigo) AS Resultado',
  { codigo: req.params.codigo }));

app.put('/api/certificados/:codigo/cancelar', (req, res) => run(res,
  `UPDATE Certificado SET Situacao = 'Cancelado', MotivoCancelamento = @motivo
   WHERE Codigo = @codigo AND Situacao = 'Emitido'`,
  { codigo: req.params.codigo, motivo: req.body.motivo }));

app.get('/api/certificados/cancelamentos', (req, res) => run(res,
  'SELECT * FROM CancelamentoCertificado ORDER BY CodCancelamento DESC'));

app.listen(3000, () => console.log('Rodando em http://localhost:3000'));