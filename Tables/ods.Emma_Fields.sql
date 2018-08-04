CREATE TABLE [ods].[Emma_Fields]
(
[FieldID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShortcutName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Required] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WidgetType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShortDisplayName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnOrder] [int] NULL,
[DeletedAt] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Options] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NOT NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_UpdatedOn] [datetime] NOT NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [ods].[Emma_Fields] ADD CONSTRAINT [PK__Emma_Fie__C8B6FF2796F0079E] PRIMARY KEY CLUSTERED  ([FieldID])
GO
