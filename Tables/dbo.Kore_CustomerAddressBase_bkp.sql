CREATE TABLE [dbo].[Kore_CustomerAddressBase_bkp]
(
[ParentId] [uniqueidentifier] NOT NULL,
[CustomerAddressId] [uniqueidentifier] NOT NULL,
[AddressNumber] [int] NULL,
[ObjectTypeCode] [int] NOT NULL,
[AddressTypeCode] [int] NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryContactName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line1] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line2] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line3] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateOrProvince] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostOfficeBox] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTCOffset] [int] NULL,
[FreightTermsCode] [int] NULL,
[UPSZone] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Latitude] [float] NULL,
[Telephone1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Longitude] [float] NULL,
[ShippingMethodCode] [int] NULL,
[Telephone2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone3] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VersionNumber] [timestamp] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[CreatedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[TimeZoneRuleVersionNumber] [int] NULL,
[OverriddenCreatedOn] [datetime] NULL,
[UTCConversionTimeZoneCode] [int] NULL,
[ImportSequenceNumber] [int] NULL,
[CreatedOnBehalfBy] [uniqueidentifier] NULL,
[TransactionCurrencyId] [uniqueidentifier] NULL,
[ExchangeRate] [decimal] (23, 10) NULL,
[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
[ParentIdTypeCode] [int] NULL,
[Composite] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[Kore_CustomerAddressBase_bkp] ADD CONSTRAINT [cndx_PrimaryKey_CustomerAddress_3] PRIMARY KEY NONCLUSTERED  ([CustomerAddressId])
GO
