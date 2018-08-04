CREATE TABLE [mdm].[tmp_MDM_STH]
(
[dimcustomerid] [int] NOT NULL,
[STH] [int] NULL,
[MPH] [int] NULL,
[Suite] [int] NULL,
[Grp] [int] NULL,
[maxPurchaseDate] [datetime] NULL,
[accountid] [int] NULL
)
GO
CREATE CLUSTERED INDEX [ix_MDM_STH] ON [mdm].[tmp_MDM_STH] ([dimcustomerid])
GO
