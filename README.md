# Controle de Presença

Sistema web para cadastro de alunos, professores, minicursos, matrículas, aulas e chamada (Presente/Ausente).

**Tecnologias:** HTML, CSS e JavaScript puro, Node.js + Express e SQL Server Express.

> Funciona apenas em **Windows**, pois usa SQL Server com Autenticação do Windows.

## Pré-requisitos

- [Node.js](https://nodejs.org) (versão LTS)
- [SQL Server Express](https://www.microsoft.com/sql-server/sql-server-downloads), com a instância `SQLEXPRESS`
- [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms)
- [ODBC Driver 18 for SQL Server](https://learn.microsoft.com/sql/connect/odbc/download-odbc-driver-for-sql-server)
- [Git](https://git-scm.com) (ou baixe o projeto em ZIP pelo botão **Code**)

## Como rodar

1. Baixe o projeto:
```
   git clone https://github.com/Luizanthony/controle-presenca.git
   cd controle-presenca
```
2. No SSMS, conecte em `.\SQLEXPRESS` e crie o banco:
```sql
   CREATE DATABASE CursoEscola;
```
3. Abra o arquivo `DataBase/banco.sql` no SSMS e execute (F5). Ele cria as tabelas, as views, as procedures, as functions, as triggers e as turmas "Turma A" e "Turma B".
4. Copie o arquivo `.env.example` para `.env` (mesma pasta). Se o seu servidor do SQL Server não se chamar `SQLEXPRESS` (ex.: `SQLEXPRESS01`), descomente a linha `DB_SERVER` e ajuste o nome.
5. Instale as dependências:
```
   npm install
```
6. Inicie o servidor:
```
   npm start
```
7. Abra no navegador: **http://localhost:3000**

> Abra sempre pelo endereço `http://localhost:3000`. Abrir o `index.html` direto pelo arquivo causa o erro "Failed to fetch".

## Como usar

Cadastre nesta ordem: Professores, Minicursos, Alunos, Matrículas, Aulas. Depois use a aba **Chamada** para marcar Presente/Ausente. As presenças são geradas automaticamente como "Ausente" por triggers do banco.

O cadastro de aluno só aceita turmas que existem na tabela `Turma`. Para liberar uma turma nova, rode no SSMS:
```sql
INSERT INTO Turma (Nome) VALUES ('Nome da turma');
```

## Recursos do banco de dados

| Tipo | Nome | O que faz |
|---|---|---|
| View | `vw_AlunosSemPresenca` | Alunos com faltas e nenhuma presença nas chamadas concluídas |
| View | `vw_CertificadosEmitidos` | Código, aluno, curso, data de emissão e situação dos certificados |
| Procedure | `sp_CadastrarAlunoNaTurma` | Verifica se a turma existe e cadastra o aluno (usada pela tela de Alunos) |
| Procedure | `sp_EmitirCertificado` | Verifica a frequência mínima (75%) e emite o certificado sem duplicidade |
| Function | `fn_MaiorSequenciaFaltas` | Maior número de faltas seguidas de um aluno nas chamadas concluídas |
| Function | `fn_ValidarCertificado` | Retorna VÁLIDO, CANCELADO ou NÃO ENCONTRADO para um código |
| Trigger | `trg_Aluno_RegistrarMudancaTurma` | Salva turma anterior, turma nova e data quando a turma do aluno muda |
| Trigger | `trg_Certificado_RegistrarCancelamento` | Ao cancelar um certificado, salva código, data, hora e motivo |
| Trigger | `trg_Aula_GerarPresencas` / `trg_Matricula_GerarPresencas` | Geram as presenças como "Ausente" automaticamente |

- **Chamada concluída** = aula com data de hoje ou anterior.
- A frequência mínima fica na procedure `sp_EmitirCertificado`, na linha marcada com `<<<`.

Exemplos no SSMS:
```sql
SELECT * FROM vw_AlunosSemPresenca;
SELECT Nome, dbo.fn_MaiorSequenciaFaltas(CodAluno) AS MaiorSequenciaFaltas FROM Aluno;
EXEC sp_EmitirCertificado @CodAluno = 1, @CodMiniCurso = 1;
SELECT * FROM vw_CertificadosEmitidos;
SELECT dbo.fn_ValidarCertificado('ALG-XXXXXXXX');
UPDATE Certificado SET Situacao = 'Cancelado', MotivoCancelamento = 'Motivo' WHERE Codigo = 'ALG-XXXXXXXX';
```

### Já tinha o banco antigo?

Não rode o `banco.sql` inteiro de novo (as tabelas antigas já existem e vai dar erro). Rode só os blocos novos, que começam nos comentários **TURMAS**, **VIEW 1 e FUNCTION 1** e **CERTIFICADOS**: selecione do comentário **TURMAS** até o fim do arquivo e aperte F5. Esses blocos podem ser executados mais de uma vez sem erro.

## Estrutura

```
server.js          API Node/Express
public/index.html  Front-end
DataBase/banco.sql Script do banco (tabelas, views, procedures, functions e triggers)
.env.example       Modelo de configuração
```