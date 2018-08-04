CREATE TABLE [apietl].[FanMaker_UserInfo_data_1]
(
[ETL__FanMaker_UserInfo_data_id] [uniqueidentifier] NOT NULL,
[ETL__FanMaker_UserInfo_id] [uniqueidentifier] NULL,
[email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_deliverable] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fanfluence] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[profile_url] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gender] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[age] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[relationship_status] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[religion] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[political] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[birthdate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_at] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tc_accepted_at] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[points_available] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[points_spent] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_points_earned] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[social_points] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticketing_points] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[membership_assignment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticketing_spend] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pos_points] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pos_spend] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[FanMaker_UserInfo_data_1] ADD CONSTRAINT [PK__FanMaker__612AF010D623BA84] PRIMARY KEY CLUSTERED  ([ETL__FanMaker_UserInfo_data_id])
GO
