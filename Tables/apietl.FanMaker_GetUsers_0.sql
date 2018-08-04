CREATE TABLE [apietl].[FanMaker_GetUsers_0]
(
[ETL__FanMaker_GetUsers_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__FanMaker___inser__23D42350] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[success] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_GetUsers_0] ADD CONSTRAINT [PK__FanMaker__B2A2EF9216F4E499] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_GetUsers_id])
GO
