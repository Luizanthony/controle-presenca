require('dotenv').config();
const express = require('express');
const sql = require('mssql/msnodesqlv8');

const app = express();
app.use(express.json());
app.use(express.static('public'));

const pool = sql.connect({
  connectionString:
    'Driver={ODBC Driver 18 for SQL Server};' +
    'Server=localhost\\SQLEXPRESS;' +
    'Database=' + (process.env.DB_NAME || 'CursoEscola') + ';' +
    'Trusted_Connection=Yes;TrustServerCertificate=Yes;'
});

async function run(res, text, params = {}) {
  try {
    const r = (await pool).request();
    for (const k in params) r.input(k, params[k]);
    const out = await r.query(text);
    res.json(out.recordset || { ok: true });
  } catch (e) { res.status(500).json({ erro: e.message }); }
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
    sel: `SELECT a.CodAula, m.Nome Minicurso, a.DataAula, a.HorarioDeInicio, a.HorarioTermino, a.Conteudo
          FROM Aula a JOIN Minicurso m ON m.CodMiniCurso = a.CodMiniCurso ORDER BY a.DataAula DESC` }
};

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

app.listen(3000, () => console.log('Rodando em http://localhost:3000'));