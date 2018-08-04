CREATE TABLE [ods].[FanMaker_Activities_Old]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime2] NULL,
[ETL__UpdatedDate] [datetime2] NULL,
[email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[identity] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subtype] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subject] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_at] [datetime2] NULL,
[source_url] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[worth] [int] NULL,
[awarded] [int] NULL
)
GO
