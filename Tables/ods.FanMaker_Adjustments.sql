CREATE TABLE [ods].[FanMaker_Adjustments]
(
[ETL__CreatedDate] [datetime] NULL,
[ETL__UpdatedDate] [datetime] NULL,
[email] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adjustment_id] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adjustment_date] [datetime] NULL,
[adjustment_reason] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adjustment_points] [int] NULL
)
GO
