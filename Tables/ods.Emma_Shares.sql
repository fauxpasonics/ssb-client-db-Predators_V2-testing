CREATE TABLE [ods].[Emma_Shares]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__IsDeleted] [bit] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account] [int] NULL,
[Mailing] [int] NULL,
[Contact] [int] NULL,
[Network] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Clicks] [bit] NULL,
[Calc_AccountId] [int] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__Emma_Shares] ON [ods].[Emma_Shares]
GO
