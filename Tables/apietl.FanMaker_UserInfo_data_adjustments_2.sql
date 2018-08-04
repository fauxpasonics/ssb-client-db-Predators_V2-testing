CREATE TABLE [apietl].[FanMaker_UserInfo_data_adjustments_2]
(
[ETL__FanMaker_UserInfo_data_adjustments_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_UserInfo_data_id] [uniqueidentifier] NULL,
[date] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reason] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[points] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_data_adjustments_2] ADD CONSTRAINT [PK__FanMaker__CBC4F7FD801B4513] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_UserInfo_data_adjustments_id])
GO
