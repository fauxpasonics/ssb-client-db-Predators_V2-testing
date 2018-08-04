CREATE TABLE [ods].[API_OutboundQueue_Emma_Members]
(
[QueueID] [bigint] NOT NULL IDENTITY(1, 1),
[APIName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[APIEntity] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EndpointName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Json_Payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[httpAction] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCompleted] [bit] NOT NULL CONSTRAINT [DF_API_OutboundQueue_Emma_MembersIsCompleted] DEFAULT ((0)),
[IsVerified] [bit] NOT NULL CONSTRAINT [DF_API_OutboundQueue_Emma_MembersIsVerified] DEFAULT ((0)),
[IsAttempted] [int] NULL CONSTRAINT [DF_API_OutboundQueue_Emma_MembersIsAttempted] DEFAULT ((0)),
[OutcomeMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Queue_ProcessDate] [datetime] NULL,
[Queue_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_API_OutboundQueue_Emma_MembersQueue_CreatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[Queue_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_API_OutboundQueue_Emma_MembersQueue_CreatedBy] DEFAULT (suser_sname()),
[Queue_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_API_OutboundQueue_Emma_MembersQueue_UpdatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[Queue_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_API_OutboundQueue_Emma_MembersQueue_UpdatedBy] DEFAULT (suser_sname()),
[MemberID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[API_OutboundQueue_Emma_Members] ADD CONSTRAINT [PK_ods_API_OutboundQueue_Emma_Members_QueueID] PRIMARY KEY CLUSTERED  ([QueueID])
GO
