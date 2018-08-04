SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [etl].[vwCRMProcess_SeasonTicketHolders]
AS
--SELECT 0 DimCustomerID, '123456' SSID, 'Season1' SeasonYear, 'SeasonYr' SeasonYr

SELECT DISTINCT CAST(dc.SSID AS VARCHAR(50)) SSID
, CAST(SeasonYear AS VARCHAR(50)) SeasonYear
, CAST(ds.SeasonYear + '-' + CONVERT(VARCHAR,(CAST(ds.SeasonYear AS INT) + 1)) AS VARCHAR(50)) SeasonYr
       FROM dbo.FactTicketSales f
       INNER JOIN dbo.DimCustomer dc ON dc.DimCustomerId = f.DimCustomerId
       INNER JOIN dbo.DimTicketType dtt ON dtt.DimTicketTypeId = f.DimTicketTypeId
	   INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = f.DimSeasonId
       --INNER JOIN dbo.DimPriceCode dpc ON dpc.DimPriceCodeId = f.DimPriceCodeId
       WHERE f.[DimTicketTypeId] in (1,2,3)
       AND ds.SeasonName LIKE '%Predators%'
	


GO
