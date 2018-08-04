CREATE TABLE [ods].[Emma_Mailings]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__IsDeleted] [bit] NOT NULL,
[ETL__DeletedDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mailing] [int] NULL,
[Account] [int] NULL,
[Parent] [int] NULL,
[Timestamp] [datetime] NULL,
[MailingsCount] [int] NULL,
[Mailing_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Signup] [int] NULL,
[Calc_AccountId] [int] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__Emma_Mailings] ON [ods].[Emma_Mailings]
GO
