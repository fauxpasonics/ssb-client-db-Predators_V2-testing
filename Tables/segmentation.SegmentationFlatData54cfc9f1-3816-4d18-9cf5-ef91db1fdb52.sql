CREATE TABLE [segmentation].[SegmentationFlatData54cfc9f1-3816-4d18-9cf5-ef91db1fdb52]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActivityIdentity] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subtype] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedAt] [datetime2] NULL,
[SourceURL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Worth] [int] NULL,
[Awarded] [int] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData54cfc9f1-3816-4d18-9cf5-ef91db1fdb52] ON [segmentation].[SegmentationFlatData54cfc9f1-3816-4d18-9cf5-ef91db1fdb52]
GO
