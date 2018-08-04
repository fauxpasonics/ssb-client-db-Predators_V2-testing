CREATE TABLE [apietl].[FanMaker_GetUsers_audit_trail_source_object_log]
(
[ETL__audit_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_GetUsers_id] [uniqueidentifier] NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__FanMaker___inser__20F7B6A5] DEFAULT (getutcdate()),
[json_payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[raw_response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_GetUsers_audit_trail_source_object_log] ADD CONSTRAINT [PK__FanMaker__5AF33E339F49E038] PRIMARY KEY CLUSTERED  ([ETL__audit_id])
GO
