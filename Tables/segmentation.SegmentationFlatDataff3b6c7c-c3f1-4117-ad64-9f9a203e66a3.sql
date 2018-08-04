CREATE TABLE [segmentation].[SegmentationFlatDataff3b6c7c-c3f1-4117-ad64-9f9a203e66a3]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Archtics_Acct_ID] [int] NULL,
[Order_Date] [date] NULL,
[Season_Year] [int] NULL,
[Season_Is_Active] [bit] NULL,
[Season_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opponent_Team_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Header_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Desc] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Class] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Date] [date] NULL,
[Event_Time] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Hierarchy_L1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Hierarchy_L2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Hierarchy_L3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Code] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Code_Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Code_Group] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC1] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC2] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC3] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC4] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRICE_TYPE] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales_Code_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Promo_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Promo_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item_Description] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item_Class] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ticket_Type_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ticket_Type_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ticket_Type_Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan_Type_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan_Type_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan_Type_Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat_Type_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat_Type_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat_Type_Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Host] [bit] NOT NULL,
[Is_Comp] [int] NOT NULL,
[Is_Premium] [bit] NOT NULL,
[Is_Discounted] [bit] NOT NULL,
[Is_Plan] [bit] NOT NULL,
[Is_Partial_Plan] [bit] NOT NULL,
[Is_Single_Event] [bit] NOT NULL,
[Is_Group] [bit] NOT NULL,
[Is_Broker] [bit] NOT NULL,
[Is_Renewal] [bit] NOT NULL,
[Comp_Code] [int] NULL,
[Section_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Row_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Seat] [int] NULL,
[Qty_Seat] [int] NOT NULL,
[Pc_Ticket] [decimal] (18, 6) NOT NULL,
[Pc_Price] [decimal] (18, 6) NOT NULL,
[Pc_Other_1] [decimal] (18, 6) NOT NULL,
[Pc_Other_2] [decimal] (18, 6) NOT NULL,
[Pc_Tax] [decimal] (18, 6) NOT NULL,
[Pc_License_Fee] [decimal] (18, 6) NOT NULL,
[Pc_Surcharge] [decimal] (18, 6) NOT NULL,
[Block_Purchase_Price] [decimal] (18, 6) NOT NULL,
[Paid_Status] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Paid_Amount] [decimal] (18, 6) NOT NULL,
[Owed_Amount] [decimal] (18, 6) NOT NULL,
[AccountRep_ID] [int] NULL,
[AccountRep_FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountRep_MiddleName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountRep_LastName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Archtics_AddUser] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatDataff3b6c7c-c3f1-4117-ad64-9f9a203e66a3] ON [segmentation].[SegmentationFlatDataff3b6c7c-c3f1-4117-ad64-9f9a203e66a3]
GO
