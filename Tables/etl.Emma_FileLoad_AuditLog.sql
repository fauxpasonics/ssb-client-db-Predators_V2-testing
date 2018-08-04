CREATE TABLE [etl].[Emma_FileLoad_AuditLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FileType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileExportDate] [date] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedDate] [datetime] NULL CONSTRAINT [DF__Emma_File__ETL____614E6BF3] DEFAULT (getdate()),
[AccountID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
