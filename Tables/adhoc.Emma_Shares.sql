CREATE TABLE [adhoc].[Emma_Shares]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mailing] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contact] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Network] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Clicks] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
