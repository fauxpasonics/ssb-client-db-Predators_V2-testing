CREATE TABLE [apietl].[FanMaker_UserInfo_data_transactions_transaction_items_3]
(
[ETL__FanMaker_UserInfo_data_transactions_transaction_items_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_UserInfo_data_transactions_id] [uniqueidentifier] NULL,
[total_cents] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_cents] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[category] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bucket] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_data_transactions_transaction_items_3] ADD CONSTRAINT [PK__FanMaker__A94B3FFCF023B13D] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_UserInfo_data_transactions_transaction_items_id])
GO
