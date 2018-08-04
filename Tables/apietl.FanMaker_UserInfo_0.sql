CREATE TABLE [apietl].[FanMaker_UserInfo_0]
(
[ETL__FanMaker_UserInfo_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__FanMaker___inser__2F45D5FC] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[success] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_0] ADD CONSTRAINT [PK__FanMaker__88C8F3DA4522B21E] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_UserInfo_id])
GO
