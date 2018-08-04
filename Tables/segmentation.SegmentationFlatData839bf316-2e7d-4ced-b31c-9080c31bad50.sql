CREATE TABLE [segmentation].[SegmentationFlatData839bf316-2e7d-4ced-b31c-9080c31bad50]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Twitter] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Foursquare] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Facebook] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Instagram] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TVTag] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Shopify] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pinterest] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tumblr] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData839bf316-2e7d-4ced-b31c-9080c31bad50] ON [segmentation].[SegmentationFlatData839bf316-2e7d-4ced-b31c-9080c31bad50]
GO
