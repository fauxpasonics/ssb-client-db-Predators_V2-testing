CREATE TABLE [segmentation].[SegmentationFlatData056dac03-9c44-4bd0-8ba8-d7350b32916e]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account] [int] NULL,
[Mailing] [int] NULL,
[Contact] [bigint] NULL,
[Timestamp] [datetime] NULL,
[Subject] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData056dac03-9c44-4bd0-8ba8-d7350b32916e] ON [segmentation].[SegmentationFlatData056dac03-9c44-4bd0-8ba8-d7350b32916e]
GO
