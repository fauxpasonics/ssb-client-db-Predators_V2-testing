CREATE TABLE [segmentation].[Emma_Deliveries]
(
[SSB_CRMSYSTEM_CONTACT_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account] [int] NULL,
[Mailing] [int] NULL,
[Contact] [bigint] NULL,
[Timestamp] [datetime] NULL,
[Result] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountDeliveries] [int] NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_keys] ON [segmentation].[Emma_Deliveries] ([SSB_CRMSYSTEM_CONTACT_ID], [Account], [Mailing], [Contact]) INCLUDE ([Email])
GO
