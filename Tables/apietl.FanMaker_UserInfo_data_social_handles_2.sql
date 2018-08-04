CREATE TABLE [apietl].[FanMaker_UserInfo_data_social_handles_2]
(
[ETL__FanMaker_UserInfo_data_social_handles_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_UserInfo_data_id] [uniqueidentifier] NULL,
[twitter] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[foursquare] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[facebook] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[instagram] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tvtag] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shopify] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pinterest] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tumblr] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_data_social_handles_2] ADD CONSTRAINT [PK__FanMaker__64E46412C960D70E] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_UserInfo_data_social_handles_id])
GO
