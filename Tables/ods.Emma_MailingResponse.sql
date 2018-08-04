CREATE TABLE [ods].[Emma_MailingResponse]
(
[MailingID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Subject] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountPurchased] [int] NULL,
[Delivered] [int] NULL,
[Clicked] [int] NULL,
[Opened] [int] NULL,
[WebviewShared] [int] NULL,
[RecipientCount] [int] NULL,
[Sent] [int] NULL,
[ClickedUnique] [int] NULL,
[WebviewShareClicked] [int] NULL,
[Shared] [int] NULL,
[InProgress] [int] NULL,
[SumPurchased] [int] NULL,
[Forwarded] [int] NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OptedOut] [int] NULL,
[SignedUp] [int] NULL,
[ShareClicked] [int] NULL,
[Bounced] [int] NULL,
[ETL_CreatedOn] [datetime] NOT NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_UpdatedOn] [datetime] NOT NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [ods].[Emma_MailingResponse] ADD CONSTRAINT [PK__Emma_Mai__224CB6DAA31D3854] PRIMARY KEY CLUSTERED  ([MailingID])
GO
