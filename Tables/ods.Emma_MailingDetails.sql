CREATE TABLE [ods].[Emma_MailingDetails]
(
[MailingID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SendStarted] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SignupFormID] [int] NULL,
[Plaintext] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientCount] [int] NULL,
[PublicWebviewURL] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailingType] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentMailingID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletedAt] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailingStatus] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendFinished] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendAt] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplyTo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HTMLBody] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NOT NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_UpdatedOn] [datetime] NOT NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [ods].[Emma_MailingDetails] ADD CONSTRAINT [PK__Emma_Mai__224CB6DAFCBC1543] PRIMARY KEY CLUSTERED  ([MailingID])
GO
