SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[Cust_FactTicketSalesProcessing_TicketTypePlanTypeSeatType]
(
	@BatchId BIGINT = 0,
	@Options NVARCHAR(MAX) = NULL,
    @FactLoadRunTime DATETIME
)
AS



BEGIN


/*****************************************************************************************************************
															PLAN TYPE
******************************************************************************************************************/

----NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   PC2 IN ('N','1')
	
		

----RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   PC2 IN ('R','2','4')



----UPGRADE----

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   PC2 IN ('U','W')



----NOPLAN----

UPDATE fts
SET fts.DimPlanTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   PC2 NOT IN ('N','R','U','W','1','2','4')






/*****************************************************************************************************************
													TICKET TYPE
******************************************************************************************************************/

----FULL SEASON----

UPDATE fts
SET fts.DimTicketTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC3 = 'F'



----HALF SEASON GOLD----

UPDATE fts
SET fts.DimTicketTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC3 = 'H' AND PlanCode LIKE '16HPG%'



----HALF SEASON BLUE----

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC3 = 'H' AND PlanCode LIKE '16HPB%'



----MINI PLAN JOSI----

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC3 = 'X' AND PlanCode LIKE '16JOSI%'



----MINI PLAN JOHANSEN----

UPDATE fts
SET fts.DimTicketTypeId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC3 = 'X' AND PlanCode LIKE '16JOHA%'



----QUARTER PLAN----

UPDATE fts
SET fts.DimTicketTypeId = 10
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC3 = 'Q'



----PARTIAL PLAN----

UPDATE fts
SET fts.DimTicketTypeId = 6
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC3 = 'Y'



----GROUP----

UPDATE fts
SET fts.DimTicketTypeId = 7
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = 'G'



----SINGLE GAME----

UPDATE fts
SET fts.DimTicketTypeId = 8
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(PC3 NOT IN ('F','H','X','Q','Y') AND PC2 NOT IN ('G')
		AND PlanCode NOT LIKE '16JOSI%' AND PlanCode NOT LIKE '16JOHA%' AND PlanCode NOT LIKE '16HPB%' AND PlanCode NOT LIKE '16HPG%')
		OR LEN(PriceCode) = 1





/*****************************************************************************************************************
													TICKET CLASS
******************************************************************************************************************/

----FULL SEASON NEW 1----

UPDATE fts
SET fts.DimTicketClassId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = 'N' AND PC3 = 'F'



----FULL SEASON NEW 2----

UPDATE fts
SET fts.DimTicketClassId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = '1' AND PC3 = 'F'



----FULL SEASON RENEWAL 1----

UPDATE fts
SET fts.DimTicketClassId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = 'R' AND PC3 = 'F'



----FULL SEASON RENEWAL 2----

UPDATE fts
SET fts.DimTicketClassId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = '2' AND PC3 = 'F'



----FULL SEASON RENEWAL 2 (2nd)----

UPDATE fts
SET fts.DimTicketClassId = 30
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = '4' AND PC3 = 'F'



----FULL SEASON UPGRADE 1----

UPDATE fts
SET fts.DimTicketClassId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = 'U' AND PC3 = 'F'



----FULL SEASON UPGRADE 2----

UPDATE fts
SET fts.DimTicketClassId = 6
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = 'W' AND PC3 = 'F'



----HALF SEASON GOLD NEW 1----

UPDATE fts
SET fts.DimTicketClassId = 7
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'N' AND PC3 = 'H' AND PlanCode = '16HPG'



----HALF SEASON GOLD NEW 2----

UPDATE fts
SET fts.DimTicketClassId = 8
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = '1' AND PC3 = 'H' AND PlanCode LIKE '16HPG%'



----HALF SEASON GOLD RENEWAL 1----

UPDATE fts
SET fts.DimTicketClassId = 9
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'R' AND PC3 = 'H' AND PlanCode LIKE '16HPG%'



----HALF SEASON GOLD RENEWAL 2----

UPDATE fts
SET fts.DimTicketClassId = 10
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = '2' AND PC3 = 'H' AND PlanCode LIKE '16HPG%'



----HALF SEASON GOLD RENEWAL 2 (2nd)----

UPDATE fts
SET fts.DimTicketClassId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = '4' AND PC3 = 'H' AND PlanCode LIKE '16HPG%'



----HALF SEASON GOLD UPGRADE 1----

UPDATE fts
SET fts.DimTicketClassId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'U' AND PC3 = 'H' AND PlanCode LIKE '16HPG%'



----HALF SEASON GOLD UPGRADE 2----

UPDATE fts
SET fts.DimTicketClassId = 14
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'W' AND PC3 = 'H' AND PlanCode LIKE '16HPG%'



----HALF SEASON BLUE NEW 1----

UPDATE fts
SET fts.DimTicketClassId = 15
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'N' AND PC3 = 'H' AND PlanCode LIKE '16HPB%'



----HALF SEASON BLUE NEW 2----

UPDATE fts
SET fts.DimTicketClassId = 16
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = '1' AND PC3 = 'H' AND PlanCode LIKE '16HPB%'



----HALF SEASON BLUE RENEWAL 1----

UPDATE fts
SET fts.DimTicketClassId = 17
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'R' AND PC3 = 'H' AND PlanCode LIKE '16HPB%'



----HALF SEASON BLUE RENEWAL 2----

UPDATE fts
SET fts.DimTicketClassId = 18
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = '2' AND PC3 = 'H' AND PlanCode LIKE '16HPB%'



----HALF SEASON BLUE RENEWAL 2 (2nd)----

UPDATE fts
SET fts.DimTicketClassId = 19
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = '4' AND PC3 = 'H' AND PlanCode LIKE '16HPB%'



----HALF SEASON BLUE UPGRADE 1----

UPDATE fts
SET fts.DimTicketClassId = 20
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'U' AND PC3 = 'H' AND PlanCode LIKE '16HPB%'



----HALF SEASON BLUE UPGRADE 2----

UPDATE fts
SET fts.DimTicketClassId = 21
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'W' AND PC3 = 'H' AND PlanCode LIKE '16HPB%'



----MINI PLAN JOSI NEW----

UPDATE fts
SET fts.DimTicketClassId = 22
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'N' AND PC3 = 'X' AND PlanCode LIKE '16JOSI%'



----MINI PLAN JOSI RENEWAL----

UPDATE fts
SET fts.DimTicketClassId = 23
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'R' AND PC3 = 'X' AND PlanCode LIKE '16JOSI%'



----MINI PLAN JOHANSEN NEW----

UPDATE fts
SET fts.DimTicketClassId = 24
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'N' AND PC3 = 'X' AND PlanCode LIKE '16JOHA%'




----MINI PLAN JOHANSEN RENEWAL----

UPDATE fts
SET fts.DimTicketClassId = 25
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC2 = 'R' AND PC3 = 'X' AND PlanCode LIKE '16JOHA%'



----QUARTER PLAN----

UPDATE fts
SET fts.DimTicketClassId = 26
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC3 = 'Q'



----PARTIAL PLAN----

UPDATE fts
SET fts.DimTicketClassId = 27
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC3 = 'Y'



----GROUP----

UPDATE fts
SET fts.DimTicketClassId = 28
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = 'G'



----SINGLE GAME----

UPDATE fts
SET fts.DimTicketClassId = 29
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(PC3 NOT IN ('F','H','X','Q','Y') AND PC2 NOT IN ('G', 'N','1','R','2','4','U','W')
		AND PlanCode NOT LIKE '16HPG%' AND PlanCode NOT LIKE '16HPB%' AND PlanCode NOT LIKE '16JOSI%' AND PlanCode NOT LIKE '16JOHA%')
		OR LEN(PriceCode) = 1






/*****************************************************************************************************************
															SEAT TYPE
******************************************************************************************************************/

----LOWER----

UPDATE fts
SET fts.DimSeatTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName IN ('100','101','102','103','104','105','106','107','108','109','110',
						'111','112','113','114','115','116','117','118','119','120')



----GARYFORCE----

UPDATE fts
SET fts.DimSeatTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName IN ('201','202','203','204','205','206','207','208','209','210','211','212',
						'213','214','215','216','217','218','219','220','221','222','223','224')


	   
----BUDLIGHT----

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName IN ('301','302','303','304','305','306','307','308','309','310','311',
						'312','313','314','315','316','317','318','319','320','321','322',
						'323','324','325','326','327','328','329','330','331','332','333')


	   
----LSL----

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName IN ('S1','S2','S3','S4','S5','S6','S7','S8','S9','S10','S11','S12','S13','S14',
						'S15','S16','S17','S18','S19','S20','S21','S22','S23','S24','S25','S26','S27',
						'S28','S29','S30','S31','S32','S33','S34','S35','S36','S37','S38','S39','S40')



----SRO----

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.RowName = 'SRO'



----UNKNOWN----

UPDATE fts
SET fts.DimSeatTypeId = -1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName NOT IN ('100','101','102','103','104','105','106','107','108','109','110','111','112',
						'113','114','115','116','117','118','119','120','201','202','203','204','205',
						'206','207','208','209','210','211','212','213','214','215','216','217','218',
						'219','220','221','222','223','224','301','302','303','304','305','306','307',
						'308','309','310','311','312','313','314','315','316','317','318','319','320',
						'321','322','323','324','325','326','327','328','329','330','331','332','333',
						'S1','S2','S3','S4','S5','S6','S7','S8','S9','S10','S11','S12','S13','S14',
						'S15','S16','S17','S18','S19','S20','S21','S22','S23','S24','S25','S26','S27',
						'S28','S29','S30','S31','S32','S33','S34','S35','S36','S37','S38','S39','S40')
		AND RowName <> 'SRO'




/*****************************************************************************************************************
													FACT TAGS
******************************************************************************************************************/


UPDATE f
SET f.IsComp = 1
FROM #stgFactTicketSales f
	JOIN dbo.DimPriceCode dpc
	ON dpc.DimPriceCodeId = f.DimPriceCodeId
WHERE f.compname <> 'Not Comp'
	  OR PriceCodeDesc = 'Comp'
	  OR f.TotalRevenue = 0


UPDATE f
SET f.IsComp = 0
FROM #stgFactTicketSales f
	JOIN dbo.DimPriceCode dpc
	ON dpc.DimPriceCodeId = f.DimPriceCodeId
WHERE NOT (f.compname <> 'Not Comp'
		   OR PriceCodeDesc = 'Comp'
		   OR f.TotalRevenue = 0)

UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 0
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM #stgFactTicketSales f
WHERE DimTicketTypeId IN (1) 



UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 1
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM #stgFactTicketSales f
WHERE DimTicketTypeId IN (2,3,4,5,6,10) 


UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 1
FROM #stgFactTicketSales f
WHERE DimTicketTypeId IN (7) 


UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 0
FROM #stgFactTicketSales f
WHERE DimTicketTypeId IN (8) 

/*
UPDATE f
SET f.IsPremium = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode <> 'GA'


UPDATE f
SET f.IsPremium = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode = 'GA'
*/


UPDATE f
SET f.IsRenewal = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.DimPlanTypeID = 2


UPDATE f
SET f.IsRenewal = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.DimPlanTypeID <> 2





END 







GO
