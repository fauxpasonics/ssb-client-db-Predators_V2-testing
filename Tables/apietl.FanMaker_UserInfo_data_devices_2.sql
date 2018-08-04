CREATE TABLE [apietl].[FanMaker_UserInfo_data_devices_2]
(
[ETL__FanMaker_UserInfo_data_devices_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_UserInfo_data_id] [uniqueidentifier] NULL,
[device_type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[os] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[app_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_data_devices_2] ADD CONSTRAINT [PK__FanMaker__BC83BFD865CA791E] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_UserInfo_data_devices_id])
GO
