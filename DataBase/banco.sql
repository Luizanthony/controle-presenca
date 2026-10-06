-- Se o seu banco já tem as tabelas, rode só a parte das TRIGGERS (final do arquivo).
CREATE TABLE Professor (
  CodProfessor INT IDENTITY PRIMARY KEY,
  Nome VARCHAR(100) NOT NULL, CPF VARCHAR(14), Email VARCHAR(100), AreaDeAtuacao VARCHAR(100));

CREATE TABLE Minicurso (
  CodMiniCurso INT IDENTITY PRIMARY KEY,
  Nome VARCHAR(100) NOT NULL, Descricao VARCHAR(300), DataInicio DATE, DataTermino DATE, CargaHoraria INT,
  CodProfessor INT NOT NULL REFERENCES Professor(CodProfessor));

CREATE TABLE Aluno (
  CodAluno INT IDENTITY PRIMARY KEY,
  Nome VARCHAR(100) NOT NULL, Email VARCHAR(100), Turma VARCHAR(20), Serie VARCHAR(20));

CREATE TABLE Matricula (
  CodMatricula INT IDENTITY PRIMARY KEY,
  CodAluno INT NOT NULL REFERENCES Aluno(CodAluno),
  CodMiniCurso INT NOT NULL REFERENCES Minicurso(CodMiniCurso),
  DataMatricula DATE DEFAULT GETDATE(),
  UNIQUE (CodAluno, CodMiniCurso));

CREATE TABLE Aula (
  CodAula INT IDENTITY PRIMARY KEY,
  DataAula DATE, HorarioInicio TIME, HorarioTermino TIME, Conteudo VARCHAR(300),
  CodMiniCurso INT NOT NULL REFERENCES Minicurso(CodMiniCurso));

CREATE TABLE ControleDePresenca (
  CodPresenca INT IDENTITY PRIMARY KEY,
  CodAluno INT NOT NULL REFERENCES Aluno(CodAluno),
  CodAula INT NOT NULL REFERENCES Aula(CodAula),
  Situacao VARCHAR(10) NOT NULL DEFAULT 'Ausente',
  Horario DATETIME NULL);
GO

-- TRIGGER 1: ao criar a aula, gera a chamada (Ausente) para todos os matriculados
CREATE TRIGGER trg_Aula_GerarPresencas ON Aula AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO ControleDePresenca (CodAluno, CodAula, Situacao)
  SELECT m.CodAluno, i.CodAula, 'Ausente'
  FROM inserted i JOIN Matricula m ON m.CodMiniCurso = i.CodMiniCurso;
END;
GO

-- TRIGGER 2: ao matricular, gera a presença das aulas que já existem
CREATE TRIGGER trg_Matricula_GerarPresencas ON Matricula AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO ControleDePresenca (CodAluno, CodAula, Situacao)
  SELECT i.CodAluno, a.CodAula, 'Ausente'
  FROM inserted i JOIN Aula a ON a.CodMiniCurso = i.CodMiniCurso;
END;
GO
