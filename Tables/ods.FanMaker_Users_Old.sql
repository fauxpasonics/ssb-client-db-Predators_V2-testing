CREATE TABLE [ods].[FanMaker_Users_Old]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime2] NULL,
[ETL__UpdatedDate] [datetime2] NULL,
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
[created_at] [datetime2] NULL,
[tc_accepted_at] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[points_available] [int] NULL,
[points_spent] [int] NULL,
[total_points_earned] [int] NULL,
[social_points] [int] NULL,
[ticketing_points] [int] NULL,
[membership_assignment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticketing_spend] [decimal] (13, 4) NULL,
[pos_points] [int] NULL,
[pos_spend] [decimal] (13, 4) NULL
)
GO
