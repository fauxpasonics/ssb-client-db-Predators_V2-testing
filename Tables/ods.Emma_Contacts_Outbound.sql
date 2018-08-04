CREATE TABLE [ods].[Emma_Contacts_Outbound]
(
[AccountID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArchticsID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondaryEmail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountRepName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountRepEmail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountRepPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBBulldog] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBSeasonTicketHolder] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBPartialPlanBuyer] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBClubTicketBuyer] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBSuiteTicketBuyer] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBGroupTicketBuyer] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBSingleGameTicketBuyer] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBParkingBuyer] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBMostRecentEvent] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBNextEvent] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBSeatLocation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSBSeatQty] [int] NULL,
[SSBTMSinceDate] [date] NULL
)
GO
