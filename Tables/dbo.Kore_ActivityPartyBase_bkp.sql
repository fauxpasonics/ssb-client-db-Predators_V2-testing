CREATE TABLE [dbo].[Kore_ActivityPartyBase_bkp]
(
[ActivityId] [uniqueidentifier] NULL,
[ActivityPartyId] [uniqueidentifier] NULL,
[PartyId] [uniqueidentifier] NULL,
[PartyObjectTypeCode] [int] NULL,
[ParticipationTypeMask] [int] NULL,
[AddressUsed] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartyIdName] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Effort] [float] NULL,
[ExchangeEntryId] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResourceSpecId] [uniqueidentifier] NULL,
[VersionNumber] [timestamp] NULL,
[DoNotPhone] [bit] NULL,
[ScheduledEnd] [datetime] NULL,
[ScheduledStart] [datetime] NULL,
[IsPartyDeleted] [bit] NULL
)
GO
