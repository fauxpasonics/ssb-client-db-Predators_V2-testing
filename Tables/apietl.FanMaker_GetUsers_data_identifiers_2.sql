CREATE TABLE [apietl].[FanMaker_GetUsers_data_identifiers_2]
(
[ETL__FanMaker_GetUsers_data_identifiers_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_GetUsers_data_id] [uniqueidentifier] NULL,
[identifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[active] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_GetUsers_data_identifiers_2] ADD CONSTRAINT [PK__FanMaker__BEC1AE449820127A] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_GetUsers_data_identifiers_id])
GO
