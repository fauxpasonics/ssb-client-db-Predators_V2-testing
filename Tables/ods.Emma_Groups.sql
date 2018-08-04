CREATE TABLE [ods].[Emma_Groups]
(
[GroupID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActiveCount] [int] NULL,
[DeletedAt] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCount] [int] NULL,
[OptoutCount] [int] NULL,
[GroupType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PurgedAt] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NOT NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_UpdatedOn] [datetime] NOT NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [ods].[Emma_Groups] ADD CONSTRAINT [PK__Emma_Gro__149AF30A30368ABA] PRIMARY KEY CLUSTERED  ([GroupID])
GO
