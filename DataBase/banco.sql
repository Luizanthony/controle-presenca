USE [CursoEscola]
GO


/****** Objeto:  Table [dbo].[Aluno]    Data do Script: 06/10/2026 15:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aluno](
	[CodAluno] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[Email] [varchar](100) NULL,
	[Turma] [varchar](50) NULL,
	[Serie] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAluno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Objeto:  Table [dbo].[Aula]    Data do Script: 06/10/2026 15:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aula](
	[CodAula] [int] IDENTITY(1,1) NOT NULL,
	[DataAula] [date] NOT NULL,
	[HorarioDeInicio] [time](7) NOT NULL,
	[HorarioTermino] [time](7) NOT NULL,
	[Conteudo] [varchar](300) NULL,
	[CodMiniCurso] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Objeto:  Table [dbo].[ControleDePresenca]    Data do Script: 06/10/2026 15:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControleDePresenca](
	[CodPresenca] [int] IDENTITY(1,1) NOT NULL,
	[CodAluno] [int] NOT NULL,
	[CodAula] [int] NOT NULL,
	[Situacao] [varchar](20) NOT NULL,
	[Horario] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPresenca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Aluno_Aula] UNIQUE NONCLUSTERED 
(
	[CodAluno] ASC,
	[CodAula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Objeto:  Table [dbo].[Matricula]    Data do Script: 06/10/2026 15:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Matricula](
	[CodMatricula] [int] IDENTITY(1,1) NOT NULL,
	[CodAluno] [int] NOT NULL,
	[CodMiniCurso] [int] NOT NULL,
	[DataMatricula] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodMatricula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Aluno_Minicurso] UNIQUE NONCLUSTERED 
(
	[CodAluno] ASC,
	[CodMiniCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Objeto:  Table [dbo].[Minicurso]    Data do Script: 06/10/2026 15:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Minicurso](
	[CodMiniCurso] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[Descricao] [varchar](300) NULL,
	[DataInicio] [date] NOT NULL,
	[DataTermino] [date] NOT NULL,
	[CargaHoraria] [int] NULL,
	[CodProfessor] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodMiniCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Objeto:  Table [dbo].[Professor]    Data do Script: 06/10/2026 15:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Professor](
	[CodProfessor] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[CPF] [varchar](14) NOT NULL,
	[Email] [varchar](100) NULL,
	[AreaDeAtuacao] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CPF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[Matricula] ADD  CONSTRAINT [DF_Matricula_DataMatricula]  DEFAULT (getdate()) FOR [DataMatricula]
GO


ALTER TABLE [dbo].[Aula]  WITH CHECK ADD FOREIGN KEY([CodMiniCurso])
REFERENCES [dbo].[Minicurso] ([CodMiniCurso])
GO


ALTER TABLE [dbo].[ControleDePresenca]  WITH CHECK ADD FOREIGN KEY([CodAluno])
REFERENCES [dbo].[Aluno] ([CodAluno])
GO


ALTER TABLE [dbo].[ControleDePresenca]  WITH CHECK ADD FOREIGN KEY([CodAula])
REFERENCES [dbo].[Aula] ([CodAula])
GO


ALTER TABLE [dbo].[Matricula]  WITH CHECK ADD FOREIGN KEY([CodAluno])
REFERENCES [dbo].[Aluno] ([CodAluno])
GO


ALTER TABLE [dbo].[Matricula]  WITH CHECK ADD FOREIGN KEY([CodMiniCurso])
REFERENCES [dbo].[Minicurso] ([CodMiniCurso])
GO


ALTER TABLE [dbo].[Minicurso]  WITH CHECK ADD FOREIGN KEY([CodProfessor])
REFERENCES [dbo].[Professor] ([CodProfessor])
GO



GO
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_Matricula_DataMatricula')
  ALTER TABLE Matricula ADD CONSTRAINT DF_Matricula_DataMatricula DEFAULT GETDATE() FOR DataMatricula;
GO
CREATE OR ALTER TRIGGER trg_Aula_GerarPresencas ON Aula AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO ControleDePresenca (CodAluno, CodAula, Situacao)
  SELECT m.CodAluno, i.CodAula, 'Ausente'
  FROM inserted i JOIN Matricula m ON m.CodMiniCurso = i.CodMiniCurso;
END;
GO
CREATE OR ALTER TRIGGER trg_Matricula_GerarPresencas ON Matricula AFTER INSERT AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO ControleDePresenca (CodAluno, CodAula, Situacao)
  SELECT i.CodAluno, a.CodAula, 'Ausente'
  FROM inserted i JOIN Aula a ON a.CodMiniCurso = i.CodMiniCurso;
END;
GO


/* =====================================================================
   TURMAS - Procedure 1 (Cadastrar aluno na turma)
            Trigger 1   (Registrar mudanca de turma)
   Pode rodar este bloco mais de uma vez sem erro.
   ===================================================================== */
USE CursoEscola;
GO

-- Tabela com as turmas validas. A procedure confere aqui antes de cadastrar.
IF OBJECT_ID('Turma') IS NULL
CREATE TABLE Turma (
  CodTurma INT IDENTITY(1,1) PRIMARY KEY,
  Nome     VARCHAR(50) NOT NULL UNIQUE   -- mesmo tamanho de Aluno.Turma
);
GO

-- Turmas validas. Para aceitar outra turma: INSERT INTO Turma (Nome) VALUES ('Nome da turma');
IF NOT EXISTS (SELECT 1 FROM Turma)
  INSERT INTO Turma (Nome) VALUES ('Turma A'), ('Turma B');
GO

-- Tabela onde o trigger guarda cada mudanca de turma.
IF OBJECT_ID('HistoricoTurma') IS NULL
CREATE TABLE HistoricoTurma (
  CodHistorico  INT IDENTITY(1,1) PRIMARY KEY,
  CodAluno      INT NOT NULL REFERENCES Aluno(CodAluno),
  TurmaAnterior VARCHAR(50) NULL,
  TurmaNova     VARCHAR(50) NULL,
  DataMudanca   DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- PROCEDURE 1: verifica se a turma existe e so entao cadastra o aluno.
CREATE OR ALTER PROCEDURE sp_CadastrarAlunoNaTurma
  @Nome  VARCHAR(100),
  @Email VARCHAR(100),
  @Turma VARCHAR(50),
  @Serie VARCHAR(30)
AS
BEGIN
  SET NOCOUNT ON;

  -- Passo 1: verificar a turma
  IF NOT EXISTS (SELECT 1 FROM Turma WHERE Nome = @Turma)
  BEGIN
    THROW 50001, N'Turma não encontrada. Cadastre a turma antes de cadastrar o aluno.', 1;
  END;

  -- Passo 2: cadastrar o aluno
  INSERT INTO Aluno (Nome, Email, Turma, Serie)
  VALUES (@Nome, @Email, @Turma, @Serie);
END;
GO

-- TRIGGER 1: quando a turma de um aluno muda, salva anterior, nova e data.
CREATE OR ALTER TRIGGER trg_Aluno_RegistrarMudancaTurma ON Aluno AFTER UPDATE AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO HistoricoTurma (CodAluno, TurmaAnterior, TurmaNova)
  SELECT i.CodAluno, d.Turma, i.Turma
  FROM inserted i
  JOIN deleted d ON d.CodAluno = i.CodAluno
  WHERE ISNULL(d.Turma, '') <> ISNULL(i.Turma, '');   -- so grava se a turma mudou
END;
GO


/* =====================================================================
   CHAMADA CONCLUIDA
   O professor faz a chamada e clica em "Concluir chamada" na tela.
   So as aulas com ChamadaConcluida = 1 contam para faltas e frequencia.
   (Os triggers criam todos como 'Ausente'; sem isso, uma chamada
   ainda nao feita contaria como falta.)
   ===================================================================== */
USE CursoEscola;
GO
IF COL_LENGTH('Aula', 'ChamadaConcluida') IS NULL
  ALTER TABLE Aula ADD ChamadaConcluida BIT NOT NULL
    CONSTRAINT DF_Aula_ChamadaConcluida DEFAULT 0;
GO


/* =====================================================================
   VIEW 1 e FUNCTION 1
   Usam so as chamadas concluidas (Aula.ChamadaConcluida = 1).
   ===================================================================== */

-- VIEW 1: alunos que tem faltas, mas nenhuma presenca nas chamadas concluidas.
CREATE OR ALTER VIEW vw_AlunosSemPresenca AS
SELECT a.CodAluno,
       a.Nome,
       a.Turma,
       COUNT(*) AS TotalFaltas
FROM Aluno a
JOIN ControleDePresenca p ON p.CodAluno = a.CodAluno
JOIN Aula au              ON au.CodAula = p.CodAula
WHERE au.ChamadaConcluida = 1                         -- so chamadas concluidas
GROUP BY a.CodAluno, a.Nome, a.Turma
HAVING SUM(CASE WHEN p.Situacao = 'Presente' THEN 1 ELSE 0 END) = 0;  -- nenhuma presenca
GO

-- FUNCTION 1: maior numero de faltas seguidas de um aluno nas chamadas concluidas.
CREATE OR ALTER FUNCTION dbo.fn_MaiorSequenciaFaltas (@CodAluno INT)
RETURNS INT
AS
BEGIN
  DECLARE @Atual INT = 0, @Maior INT = 0, @Situacao VARCHAR(20);

  -- percorre as chamadas do aluno em ordem de data
  DECLARE c CURSOR LOCAL FAST_FORWARD FOR
    SELECT p.Situacao
    FROM ControleDePresenca p
    JOIN Aula a ON a.CodAula = p.CodAula
    WHERE p.CodAluno = @CodAluno
      AND a.ChamadaConcluida = 1
    ORDER BY a.DataAula, a.HorarioDeInicio, a.CodAula;

  OPEN c;
  FETCH NEXT FROM c INTO @Situacao;
  WHILE @@FETCH_STATUS = 0
  BEGIN
    IF @Situacao = 'Ausente'
    BEGIN
      SET @Atual = @Atual + 1;                    -- mais uma falta seguida
      IF @Atual > @Maior SET @Maior = @Atual;     -- guarda o recorde
    END
    ELSE
      SET @Atual = 0;                             -- presenca zera a contagem
    FETCH NEXT FROM c INTO @Situacao;
  END;
  CLOSE c;
  DEALLOCATE c;

  RETURN @Maior;
END;
GO


/* =====================================================================
   CERTIFICADOS - Procedure 2 (Emitir certificado)
                  View 2      (Certificados emitidos)
                  Function 2  (Validar certificado)
                  Trigger 2   (Registrar cancelamento de certificado)
   ===================================================================== */

-- Tabela dos certificados
IF OBJECT_ID('Certificado') IS NULL
CREATE TABLE Certificado (
  CodCertificado     INT IDENTITY(1,1) PRIMARY KEY,
  Codigo             VARCHAR(20) NOT NULL UNIQUE,
  CodAluno           INT NOT NULL REFERENCES Aluno(CodAluno),
  CodMiniCurso       INT NOT NULL REFERENCES Minicurso(CodMiniCurso),
  DataEmissao        DATETIME NOT NULL DEFAULT GETDATE(),
  Situacao           VARCHAR(20) NOT NULL DEFAULT 'Emitido'
                     CHECK (Situacao IN ('Emitido', 'Cancelado')),
  MotivoCancelamento VARCHAR(200) NULL
);
GO

-- Tabela onde o trigger 2 registra cada cancelamento
IF OBJECT_ID('CancelamentoCertificado') IS NULL
CREATE TABLE CancelamentoCertificado (
  CodCancelamento  INT IDENTITY(1,1) PRIMARY KEY,
  Codigo           VARCHAR(20) NOT NULL,
  DataCancelamento DATE    NOT NULL DEFAULT CAST(GETDATE() AS DATE),
  HoraCancelamento TIME(0) NOT NULL DEFAULT CAST(GETDATE() AS TIME(0)),
  Motivo           VARCHAR(200) NOT NULL
);
GO

-- PROCEDURE 2: verifica a frequencia e emite o certificado sem duplicidade.
CREATE OR ALTER PROCEDURE sp_EmitirCertificado
  @CodAluno     INT,
  @CodMiniCurso INT
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @FrequenciaMinima DECIMAL(5,2) = 75;