CREATE TABLE [apietl].[FanMaker_UserInfo_data_category_spend_2]
(
[ETL__FanMaker_UserInfo_data_category_spend_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_UserInfo_data_id] [uniqueidentifier] NULL,
[name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[spend] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_data_category_spend_2] ADD CONSTRAINT [PK__FanMaker__A1F92A2E5FC638F2] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_UserInfo_data_category_spend_id])
GO
