CREATE TABLE [apietl].[FanMaker_UserInfo_audit_trail_source_object_log]
(
[ETL__audit_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_UserInfo_id] [uniqueidentifier] NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__FanMaker___inser__2C696951] DEFAULT (getutcdate()),
[json_payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[raw_response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_audit_trail_source_object_log] ADD CONSTRAINT [PK__FanMaker__5AF33E3363286C8E] PRIMARY KEY CLUSTERED  ([ETL__audit_id])
GO
