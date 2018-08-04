CREATE TABLE [segmentation].[SegmentationFlatDatab38ab9d8-c981-451f-91a1-9c2ea205b041]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AppName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatDatab38ab9d8-c981-451f-91a1-9c2ea205b041] ON [segmentation].[SegmentationFlatDatab38ab9d8-c981-451f-91a1-9c2ea205b041]
GO
