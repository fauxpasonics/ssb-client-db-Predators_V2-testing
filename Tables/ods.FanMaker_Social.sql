CREATE TABLE [ods].[FanMaker_Social]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__UpdatedDate] [datetime2] NULL,
[email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[twitter] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[foursquare] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[facebook] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[instagram] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tvtag] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shopify] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pinterest] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tumblr] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FanMakerSocialDirtyHash] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
