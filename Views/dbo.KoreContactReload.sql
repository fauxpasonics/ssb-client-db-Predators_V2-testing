SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[KoreContactReload]
AS

SELECT kcr.*, ISNULL(line1,'') + ISNULL(line2,'') AS StreetAddress, city, ad.StateOrProvince, county, country, postalcode
FROM [Predators].[stg].[KoreContactReload] kcr
JOIN dbo.Kore_CustomerAddressBase_bkp ad ON kcr.contactid = ad.ParentId
where AddressNumber = 1
GO
