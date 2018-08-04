CREATE TABLE [ods].[FanMaker_Transactions_Old]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime2] NULL,
[ETL__UpdatedDate] [datetime] NULL,
[transaction_id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transaction_number] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location_id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[terminal_id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[member_id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[category] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bucket] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[purchased_at] [datetime2] NULL,
[created_at] [datetime2] NULL,
[data_type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[table_number] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_cents] [int] NULL,
[price_cents] [int] NULL,
[quantity] [int] NULL
)
GO
