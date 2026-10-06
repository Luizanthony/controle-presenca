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
