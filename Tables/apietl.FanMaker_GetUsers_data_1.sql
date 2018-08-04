CREATE TABLE [apietl].[FanMaker_GetUsers_data_1]
(
[ETL__FanMaker_GetUsers_data_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_GetUsers_id] [uniqueidentifier] NULL,
[username] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_at] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_GetUsers_data_1] ADD CONSTRAINT [PK__FanMaker__2D623F2BCE3D9724] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_GetUsers_data_id])
GO
