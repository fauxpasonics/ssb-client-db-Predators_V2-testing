CREATE TABLE [segmentation].[SegmentationFlatData40d34051-b128-4290-8765-271a5c2a25bd]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailDeliverable] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FanmakerFirstName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FanmakerLastName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fanfluence] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProfileURL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelationshipStatus] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Religion] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Political] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birthdate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedAt] [datetime2] NULL,
[TCAcceptedAt] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PointsAvailable] [int] NULL,
[PointsSpent] [int] NULL,
[TotalPointsEarned] [int] NULL,
[SocialPoints] [int] NULL,
[TicketingPoints] [int] NULL,
[TicketingSpend] [decimal] (13, 4) NULL,
[POSPoints] [int] NULL,
[POSSpend] [decimal] (13, 4) NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData40d34051-b128-4290-8765-271a5c2a25bd] ON [segmentation].[SegmentationFlatData40d34051-b128-4290-8765-271a5c2a25bd]
GO
