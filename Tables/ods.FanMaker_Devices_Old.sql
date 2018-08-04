CREATE TABLE [ods].[FanMaker_Devices_Old]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__UpdatedDate] [datetime] NULL,
[email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[device_type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[os] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[app_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
