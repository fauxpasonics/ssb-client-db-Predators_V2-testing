CREATE TABLE [segmentation].[SegmentationFlatData4bf61469-9dd2-4904-b151-ad0ac7c7b5c0]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Archtics_Acct_Id] [int] NULL,
[O_Activity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Activity_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Transaction_Date] [date] NULL,
[O_Season_Year] [int] NULL,
[O_Event_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Event_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Event_Time] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Event_Date] [datetime] NULL,
[O_Section_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Row_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_First_Seat] [int] NULL,
[O_Qty_Seat] [int] NULL,
[O_Orig_purchase_price] [numeric] (29, 2) NULL,
[O_TE_Purchase_Price] [numeric] (18, 0) NULL,
[O_TE_Price_Difference] [numeric] (30, 0) NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData4bf61469-9dd2-4904-b151-ad0ac7c7b5c0] ON [segmentation].[SegmentationFlatData4bf61469-9dd2-4904-b151-ad0ac7c7b5c0]
GO
