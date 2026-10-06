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
3. Abra o arquivo `DataBase/banco.sql` no SSMS e execute (F5). Ele cria as tabelas e as triggers.
4. Copie o arquivo `.env.example` para `.env` (mesma pasta, sem alterar o conteúdo).
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

## Estrutura

```
server.js          API Node/Express
public/index.html  Front-end
DataBase/banco.sql Script do banco (tabelas e triggers)
.env.example       Modelo de configuração
```