CREATE TABLE [apietl].[FanMaker_UserInfo_data_visits_2]
(
[ETL__FanMaker_UserInfo_data_visits_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_UserInfo_data_id] [uniqueidentifier] NULL,
[last_login] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[desktop] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mobile] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_data_visits_2] ADD CONSTRAINT [PK__FanMaker__87B990D2BA0324B4] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_UserInfo_data_visits_id])
GO
