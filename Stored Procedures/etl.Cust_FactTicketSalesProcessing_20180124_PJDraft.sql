SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[Cust_FactTicketSalesProcessing_20180124_PJDraft]
(
	@BatchId INT = 0,
	@LoadDate DATETIME = NULL,
	@Options NVARCHAR(MAX) = NULL
)

AS


BEGIN


/*****************************************************************************************************************
															PLAN TYPE
******************************************************************************************************************/

----NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterId = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'PRED1617' AND PC2 IN ('N','1'))
OR		(SeasonCode = 'PRED1718' AND PC4 = 'N') 
	
		

----RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 2
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'PRED1617' AND PC2 IN ('R','2','4'))
OR		(SeasonCode = 'PRED1718' AND (PC4 IN ('R', 'F', 'C', 'A') OR RIGHT(pricecode,2) IN ('QR', 'XR') ) AND RIGHT(pricecode,2) NOT IN ('WC', 'NC'))  
-- New Addition Excludes yearly upgrade where Price Code ends in WC



----UPGRADE (PRODUCT)----

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'PRED1617' AND PC2 = 'U')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'U')



----UPGRADE (Yearly)----

UPDATE fts
SET fts.DimPlanTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'PRED1617' AND PC2 = 'W')
OR		(SeasonCode = 'PRED1718' AND (PC4 = 'W' OR RIGHT(PriceCode,2) = 'WC'))  --Addition of Yearly Upgrade



----LEXUS LOUNGE NEW----

UPDATE fts
SET fts.DimPlanTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'PRED1617' AND PC2 IN ('3','5'))
OR		(SeasonCode = 'PRED1718' AND PC4 = 'C' AND PC3 = 'N')



----LEXUS LOUNGE RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 8
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'PRED1718' AND PC4 = 'C' AND PC3 = 'F')



----EXTENDED----

UPDATE fts
SET fts.DimPlanTypeId = 7
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'PRED1718' AND PC4 = 'E')



----NOPLAN----

UPDATE fts
SET fts.DimPlanTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'PRED1617' AND (PC2 NOT IN ('N','R','U','W','1','2','4','3','5') OR PC2 IS NULL))
OR		(SeasonCode = 'PRED1718' AND (PC4 NOT IN ('N','R','F','A','E','U','W','C') OR PC4 IS NULL AND RIGHT(PriceCode,2) <> 'WC' AND RIGHT(pricecode,2) NOT IN ('QR', 'XR'))) -- Added in WC renewal type






/*****************************************************************************************************************
													TICKET TYPE
******************************************************************************************************************/

----FULL SEASON----

UPDATE fts
SET fts.DimTicketTypeId = 1
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1617' AND PC3 = 'F')
OR		(SeasonCode = 'PRED1718' AND (PC3 IN ('F','E') OR ItemCode LIKE '17FS%'))



----HALF SEASON (updated)---- 
UPDATE fts
SET fts.DimTicketTypeId = 13 --May need new ticket type or can use existing one
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC3 = 'H' AND PlanCode LIKE '16HP%')
OR		(SeasonCode = 'PRED1718' AND (PC3 IN ('H', 'I') OR ItemCode LIKE '17HP%'))

----HALF SEASON GOLD---- 
     
/****** Looks like they've combined half season plans but we may want to keep this level of granularity ******/


UPDATE fts
SET fts.DimTicketTypeId = 2
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC3 = 'H' AND PlanCode LIKE '16HPG%')
OR		(SeasonCode = 'PRED1718' AND PC3 IN ('H', 'I') AND PlanCode LIKE '17HPG%')



----HALF SEASON BLUE----

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC3 = 'H' AND PlanCode LIKE '16HPB%')
OR		(SeasonCode = 'PRED1718' AND PC3 IN ('H', 'I') AND PlanCode LIKE '17HPB%')



----HALF SEASON PICKEM PLAN----

UPDATE fts
SET fts.DimTicketTypeId = 13
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimPlan di ON fts.DimPlanId = di.DimPlanId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1718' AND PC3 IN ('H', 'I') AND PlanCode LIKE '17HPP%')



----FULL SEASON SUITES----

UPDATE fts
SET fts.DimTicketTypeId = 14
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeID = fts.DimPriceCodeID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	SeasonCode = 'PRED1718' AND PC3 IN ('F','E') AND PriceCodeDesc LIKE '%Suite%'



----HALF SEASON SUITES----

UPDATE fts
SET fts.DimTicketTypeId = 12
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeID = fts.DimPriceCodeID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PC3 IN ('H', 'I') AND PriceCodeDesc LIKE '%Suite%'




----MINI PLAN JOSI----

/****** Looks like they've combined mini plans, flex plans, and quarter plans into partial plans but we may want to keep this level of granularity ******/

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	SeasonCode = 'PRED1617' AND PC3 = 'X' AND PlanCode LIKE '16JOSI%'



------MINI PLAN JOHANSEN----

UPDATE fts
SET fts.DimTicketTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	SeasonCode = 'PRED1617' AND PC3 = 'X' AND PlanCode LIKE '16JOHA%'



------Flex Plan----

UPDATE fts
SET fts.DimTicketTypeID = 11
FROM	dbo.FactTicketSales fts
		INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
		INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.dimDate dimdate ON dimdate.DimDateId = fts.DimDateId
		join dbo.dimseason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC3 = 'X' AND PlanCode NOT LIKE '16JOHA%' AND PlanCode NOT LIKE '16JOSI%')
OR		(SeasonCode = 'PRED1718' AND PC3 = 'X')



------QUARTER PLAN----

UPDATE fts
SET fts.DimTicketTypeId = 10
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode = 'PRED1617' AND PC3 = 'Q'



----PARTIAL PLAN----

UPDATE fts
SET fts.DimTicketTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode = 'PRED1718' 
AND 
(PC2 IN ('X', 'Q') OR itemcode IN ('1710GOLD','1710SMSH','17107MAN')  OR RIGHT(pricecode,2) = 'YN' OR RIGHT(pricecode,2) = 'XR' OR RIGHT(pricecode,2) = 'QR') --Updated to include quarter renewals


----GROUP----

UPDATE fts
SET fts.DimTicketTypeId = 7
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(PC2 = 'G' OR RIGHT(Pricecode,2) = 'GB')
AND  RIGHT(Pricecode,2) NOT IN ('NG', 'OG', 'L4', 'B4', 'VN') ---Updated to include Beerfest Group Tickets


------Suite Rental--------

UPDATE fts
SET fts.DimTicketTypeId = 15 --Need New Ticket Type
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	 RIGHT(Pricecode,2) IN ('NG', 'OG', 'L4', 'B4', 'VN')


----SINGLE GAME----

UPDATE fts
SET fts.DimTicketTypeId = 8
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND (PC3 NOT IN ('F','H','X','Q','Y') OR PC3 IS NULL) AND (PC2 NOT IN ('G') OR PC2 IS NULL)
		AND PlanCode NOT LIKE '16JOSI%' AND PlanCode NOT LIKE '16JOHA%' AND PlanCode NOT LIKE '16HPB%' AND PlanCode NOT LIKE '16HPG%')
OR		(SeasonCode = 'PRED1718' AND (PC3 NOT IN ('F','H','X','Q','Y') OR PC3 IS NULL) AND (PC2 NOT IN ('G') OR PC2 IS NULL OR RIGHT(pricecode,2) IN ('PP', 'FP', 'HP', 'PC', 'LP', 'UP'))
		AND PlanCode NOT LIKE '17HPP%' AND PlanCode NOT LIKE '17HPB%' AND PlanCode NOT LIKE '17HPG%') 
		 -- Addition OF ADD ON Tickets
		 --need clarification on properly adding in the add on tickets
		




		

/*****************************************************************************************************************
													TICKET CLASS
******************************************************************************************************************/

----FULL SEASON NEW 1----

UPDATE fts
SET fts.DimTicketClassId = 1
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'N' AND PC3 = 'F')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'N' AND PC3 IN ('F','E') AND PC2 = '0')



----FULL SEASON NEW 2----

UPDATE fts
SET fts.DimTicketClassId = 2
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '1' AND PC3 = 'F')



----FULL SEASON NEW 3----

UPDATE fts
SET fts.DimTicketClassId = 38
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1718' AND PC4 = 'N' AND PC3 IN ('F', 'E') AND PC2 IN ('1', '2', '3'))




----FULL SEASON RENEWAL 1----

UPDATE fts
SET fts.DimTicketClassId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'R' AND PC3 = 'F')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC3 IN ('F','E') AND PC2 = '0')




----FULL SEASON RENEWAL 2----

UPDATE fts
SET fts.DimTicketClassId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '2' AND PC3 = 'F')




----FULL SEASON RENEWAL 2 (2nd)----

UPDATE fts
SET fts.DimTicketClassId = 30
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '4' AND PC3 = 'F')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC3 IN ('F', 'E') AND PC2 = '4')




----FULL SEASON PRODUCT UPGRADE 1----

UPDATE fts
SET fts.DimTicketClassId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'U' AND PC3 = 'F')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'U' AND PC3 IN ('F', 'E') AND PC2 = '0')




----FULL SEASON YEARLY UPGRADE 2----

UPDATE fts
SET fts.DimTicketClassId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'W' AND PC3 = 'F')




----FULL SEASON YEARLY UPGRADE 3----

UPDATE fts
SET fts.DimTicketClassId = 37
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'PRED1718' AND PC4 = 'W' AND PC3 IN ('F', 'E') AND PC2 IN ('1', '2', '3'))



/*
----FULL SEASON LEXUS 3----

UPDATE fts
SET fts.DimTicketClassId = 33
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = '3' AND (PC3 = 'F' OR di.ItemCode LIKE '17FS%' OR di.ItemCode LIKE '16FS%')




----FULL SEASON LEXUS 5----

UPDATE fts
SET fts.DimTicketClassId = 34
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = '5' AND (PC3 = 'F' OR di.ItemCode LIKE '17FS%' OR di.ItemCode LIKE '16FS%')
*/



----HALF SEASON GOLD NEW 1----

UPDATE fts
SET fts.DimTicketClassId = 7
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'N' AND PC3 = 'H' AND PlanCode LIKE '16HPG%')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'N' AND PC2 = '0' AND PlanCode LIKE '17HPG%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON GOLD NEW 2----

UPDATE fts
SET fts.DimTicketClassId = 8
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '1' AND PC3 = 'H' AND PlanCode LIKE '16HPG%')



----HALF SEASON GOLD RENEWAL 1----

UPDATE fts
SET fts.DimTicketClassId = 9
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'R' AND PC3 = 'H' AND PlanCode LIKE '16HPG%')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC2 = '0' AND PlanCode LIKE '17HPG%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON GOLD RENEWAL 2----

UPDATE fts
SET fts.DimTicketClassId = 10
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '2' AND PC3 = 'H' AND PlanCode LIKE '16HPG%')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC2 IN ('4', '5') AND PlanCode LIKE '17HPG%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON GOLD RENEWAL 2 (2nd)----

UPDATE fts
SET fts.DimTicketClassId = 11
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '4' AND PC3 = 'H' AND PlanCode LIKE '16HPG%')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC2 IN ('1') AND PlanCode LIKE '17HPG%' 
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON GOLD PRODUCT UPGRADE 1----

UPDATE fts
SET fts.DimTicketClassId = 13
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'U' AND PC3 = 'H' AND PlanCode LIKE '16HPG%')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'U' AND PC2 = '0' AND PlanCode LIKE '17HPG%' 
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON GOLD YEARLY UPGRADE 2----

UPDATE fts
SET fts.DimTicketClassId = 14
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'W' AND PC3 = 'H' AND PlanCode LIKE '16HPG%')



----HALF SEASON GOLD YEARLY UPGRADE 3----

UPDATE fts
SET fts.DimTicketClassId = 39
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1718' AND PC4 = 'U' AND PC2 = '1' AND PlanCode LIKE '17HPG%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON BLUE NEW 1----

UPDATE fts
SET fts.DimTicketClassId = 15
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'N' AND PC3 = 'H' AND PlanCode LIKE '16HPB%')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'N' AND PC2 = '0' AND PlanCode LIKE '17HPB%' 
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON BLUE NEW 2----

UPDATE fts
SET fts.DimTicketClassId = 16
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '1' AND PC3 = 'H' AND PlanCode LIKE '17HPB%')



----HALF SEASON BLUE RENEWAL 1----

UPDATE fts
SET fts.DimTicketClassId = 17
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'R' AND PC3 = 'H' AND PlanCode LIKE '16HPB%')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC2 = '0' AND PlanCode LIKE '17HPB%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON BLUE RENEWAL 2----

UPDATE fts
SET fts.DimTicketClassId = 18
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '2' AND PC3 = 'H' AND PlanCode LIKE '16HPB%')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC2 IN ('4', '5') AND PlanCode LIKE '17HPB%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON BLUE RENEWAL 2 (2nd)----

UPDATE fts
SET fts.DimTicketClassId = 19
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = '4' AND PC3 = 'H' AND PlanCode LIKE '16HPB%')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC2 IN ('1') AND PlanCode LIKE '17HPB%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON BLUE PRODUCT UPGRADE 1----

UPDATE fts
SET fts.DimTicketClassId = 20
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'U' AND PC3 = 'H' AND PlanCode LIKE '16HPB%')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'U' AND PC2 = '0' AND PlanCode LIKE '17HPB%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON BLUE YEARLY UPGRADE 2----

UPDATE fts
SET fts.DimTicketClassId = 21
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'W' AND PC3 = 'H' AND PlanCode LIKE '16HPB%')



----HALF SEASON BLUE YEARLY UPGRADE 3----

UPDATE fts
SET fts.DimTicketClassId = 39
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1718' AND PC4 = 'U' AND PC2 = '1' AND PlanCode LIKE '17HPB%'
		AND PriceCode.PC3 IN ('H', 'I'))



----HALF SEASON SUITE NEW----

UPDATE fts
SET fts.DimTicketClassId = 35
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeID = fts.DimPriceCodeID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'N' AND PC3 = 'H' AND PriceCodeDesc LIKE '%Suite%')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'N' AND PC3 IN ('H', 'I') AND PriceCodeDesc LIKE '%Suite%')


----HALF SEASON SUITE RENEW----

UPDATE fts
SET fts.DimTicketClassId = 36
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeID = fts.DimPriceCodeID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'R' AND PC3 = 'H' AND PriceCodeDesc LIKE '%Suite%')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC3 IN ('H', 'I') AND PriceCodeDesc LIKE '%Suite%')


----FULL SEASON SUITE NEW----

UPDATE fts
SET fts.DimTicketClassId = 42
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeID = fts.DimPriceCodeID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'N' AND PC3 = 'F' AND PriceCodeDesc LIKE '%Suite%')
OR		(SeasonCode = 'PRED1718' AND PC4 = 'N' AND PC3 IN ('F', 'E') AND PriceCodeDesc LIKE '%Suite%')


----FULL SEASON SUITE RENEW----

UPDATE fts
SET fts.DimTicketClassId = 43
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeID = fts.DimPriceCodeID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'R' AND PC3 = 'F' AND PriceCodeDesc LIKE '%Suite%')
OR		(SeasonCode = 'PRED1718' AND PC4 IN ('R', 'A', 'F') AND PC3 IN ('F', 'E') AND PriceCodeDesc LIKE '%Suite%')


----MINI PLAN JOSI NEW----

UPDATE fts
SET fts.DimTicketClassId = 22
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'N' AND PC3 = 'X' AND PlanCode LIKE '16JOSI%')



----MINI PLAN JOSI RENEWAL----

UPDATE fts
SET fts.DimTicketClassId = 23
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'R' AND PC3 = 'X' AND PlanCode LIKE '16JOSI%')



----MINI PLAN JOHANSEN NEW----

UPDATE fts
SET fts.DimTicketClassId = 24
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'N' AND PC3 = 'X' AND PlanCode LIKE '16JOHA%')




----MINI PLAN JOHANSEN RENEWAL----

UPDATE fts
SET fts.DimTicketClassId = 25
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'R' AND PC3 = 'X' AND PlanCode LIKE '16JOHA%')



----FLEX PLAN NEW----

UPDATE fts
SET fts.DimTicketClassId = 31
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'N' AND PC3 = 'X' AND PlanCode NOT LIKE '16JOHA%' AND PlanCode NOT LIKE '16JOSI%')
OR		(SeasonCode = 'PRED1718' AND RIGHT(PriceCode.PriceCode,2) = 'XN')



----FLEX PLAN RENEWAL----

UPDATE fts
SET fts.DimTicketClassId = 32
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'PRED1617' AND PC2 = 'R' AND PC3 = 'X' AND PlanCode NOT LIKE '16JOHA%' AND PlanCode NOT LIKE '16JOSI%')
OR		(SeasonCode = 'PRED1718' AND RIGHT(pricecode,2) = 'XR')



----QUARTER PLAN----

UPDATE fts
SET fts.DimTicketClassId = 26
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode = 'PRED1617' AND PC3 = 'Q'
OR (SeasonCode = 'PRED1718' AND RIGHT(pricecode,2) = 'QR')

/*For Quarters/Partials/Flex do we want to keep the seperation in ticket class and just have ticket type of partial plan? 
as of now this last update means ticket class of flex and quarter would not exist on Fact Ticket Sales
  */

----PARTIAL PLAN----

UPDATE fts
SET fts.DimTicketClassId = 27
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode = 'PRED1718' AND (itemcode IN ('1710GOLD','1710SMSH','17107MAN') OR RIGHT(pricecode,2) IN ('YN' ,'XR' ,'QR'))



----GROUP----



UPDATE fts
SET fts.DimTicketClassId = 28
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PC2 = 'G' AND SeasonCode = 'PRED1617'






--Traditional Group -- 

UPDATE fts
SET fts.DimTicketClassId = 44 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE seasoncode = 'PRED1718' AND RIGHT(Pricecode,2) IN ('G1', 'G2', 'G3')

--Concert Buyers Group -- 

UPDATE fts
SET fts.DimTicketClassId = 45 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE seasoncode = 'PRED1718' AND RIGHT(Pricecode,2) = 'G4'

--Fundraisers Group -- 

UPDATE fts
SET fts.DimTicketClassId = 46 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE seasoncode = 'PRED1718' AND  RIGHT(Pricecode,2) = 'G5'

--AHFD Group -- 

UPDATE fts
SET fts.DimTicketClassId = 47 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE seasoncode = 'PRED1718' AND RIGHT(Pricecode,2) = 'G6'


--Gold Friday Group -- 

UPDATE fts
SET fts.DimTicketClassId = 48 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE seasoncode = 'PRED1718' AND  RIGHT(Pricecode,2) = 'G7'


--Fevo Group -- 

UPDATE fts
SET fts.DimTicketClassId = 49 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) IN ('G8','G9')

--Beerfest Group -- 

UPDATE fts
SET fts.DimTicketClassId = 50 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) ='GB'

--College Group -- 

UPDATE fts
SET fts.DimTicketClassId = 51 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'GC'

--Golden Perks Groups-- 

UPDATE fts
SET fts.DimTicketClassId = 52 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'GP'


--Preds Perks Groups-- 

UPDATE fts
SET fts.DimTicketClassId = 53 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'GV'


--Military Groups-- 

UPDATE fts
SET fts.DimTicketClassId = 54 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'GM'

--Ticket Banks Groups-- 

UPDATE fts
SET fts.DimTicketClassId = 55 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'GT'

----SINGLE GAME----

UPDATE fts
SET fts.DimTicketClassId = 29
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	DimTicketTypeID = 8


/*Addition of Single Game Add ONs*/


--Full Add On-- 

UPDATE fts
SET fts.DimTicketClassId = 57 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'FP'


--Half Add On-- 

UPDATE fts
SET fts.DimTicketClassId = 58 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'HP'


--Partial Add On-- 

UPDATE fts
SET fts.DimTicketClassId = 59 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'PP'

--Lexus Lounge Add On-- 

UPDATE fts
SET fts.DimTicketClassId = 60 -- New Ticket Class Needed
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE RIGHT(Pricecode,2) = 'PC'


/*****************************************************************************************************************
															SEAT TYPE
******************************************************************************************************************/

----LOWER----

UPDATE fts
SET fts.DimSeatTypeId = 1
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName IN ('100','101','102','103','104','105','106','107','108','109','110',
						'111','112','113','114','115','116','117','118','119','120')



----GARYFORCE----

UPDATE fts
SET fts.DimSeatTypeId = 2
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName IN ('201','202','203','204','205','206','207','208','209','210','211','212',
						'213','214','215','216','217','218','219','220','221','222','223','224')


	   
----BUDLIGHT----

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
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
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName IN ('S 1','S 2','S 3','S 4','S 5','S 6','S 7','S 8','S 9','S 10','S 11','S 12','S 13','S 14',
						'S 15','S 16','S 17','S 18','S 19','S 20','S 21','S 22','S 23','S 24','S 25','S 26','S 27',
						'S 28','S 29','S 30','S 31','S 32','S 33','S 34','S 35','S 36','S 37','S 38','S 39','S 40', 'S 41', 'S 42')



----SRO----

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.RowName = 'SRO'



----TTOPS----
UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName = 'TTOPS'



----GFA SUITES----
UPDATE fts
SET fts.DimSeatTypeId = 7
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName IN ('S C1', 'S C2', 'S C3', 'S C4', 'S C5', 'S C6', 'S C7', 'S C8', 'S C9', 'S C10',
						'S C11', 'S C12', 'S C13', 'S C14', 'S C15', 'S C16', 'S C17', 'S C18', 'S C19',
						'S C20', 'S C21', 'S C22', 'S C23', 'S C24', 'S C25', 'S C26', 'S C27', 'S C28',
						'S C29', 'S C30')



----501 CLUB----
UPDATE fts
SET fts.DimSeatTypeId = 8
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName = 'S 501'



----GENERAL ADMISSION----
UPDATE fts
SET fts.DimSeatTypeId = 9
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE s.SectionName LIKE 'GA%'



----UNKNOWN----

UPDATE fts
SET fts.DimSeatTypeId = -1
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCodeMaster PriceCode ON PriceCode.DimPriceCodeMasterID = fts.DimPriceCodeMasterID
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
						'S 1','S 2','S 3','S 4','S 5','S 6','S 7','S 8','S 9','S 10','S 11','S 12','S 13','S 14',
						'S 15','S 16','S 17','S 18','S 19','S 20','S 21','S 22','S 23','S 24','S 25','S 26','S 27',
						'S 28','S 29','S 30','S 31','S 32','S 33','S 34','S 35','S 36','S 37','S 38','S 39','S 40',
						'S 41', 'S 42', 'S C1', 'S C2', 'S C3', 'S C4', 'S C5', 'S C6', 'S C7', 'S C8', 'S C9', 'S C10',
						'S C11', 'S C12', 'S C13', 'S C14', 'S C15', 'S C16', 'S C17', 'S C18', 'S C19',
						'S C20', 'S C21', 'S C22', 'S C23', 'S C24', 'S C25', 'S C26', 'S C27', 'S C28',
						'S C29', 'S C30', 'S 501')
		AND s.SectionName NOT LIKE 'TTOPS%' AND SectionName NOT LIKE 'GA%'
		AND RowName <> 'SRO'




/*****************************************************************************************************************
													FACT TAGS
******************************************************************************************************************/


UPDATE f
SET f.IsComp = 1
FROM dbo.FactTicketSales f
	JOIN dbo.DimPriceCodeMaster dpc
	ON dpc.DimPriceCodeMasterID = f.DimPriceCodeMasterID
WHERE f.compname <> 'Not Comp'
	  --OR PriceCodeDesc = 'Comp'
	  OR f.TotalRevenue = 0


UPDATE f
SET f.IsComp = 0
FROM dbo.FactTicketSales f
	JOIN dbo.DimPriceCodeMaster dpc
	ON dpc.DimPriceCodeMasterID = f.DimPriceCodeMasterID
WHERE NOT (f.compname <> 'Not Comp'
		   --OR PriceCodeDesc = 'Comp'
		   OR f.TotalRevenue = 0)

UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 0
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM dbo.FactTicketSales f
WHERE DimTicketTypeId IN (1) 



UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 1
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM dbo.FactTicketSales f
WHERE DimTicketTypeId IN (2,3,4,5,6,10) 


UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 1
FROM dbo.FactTicketSales f
WHERE DimTicketTypeId IN (7) 


UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 0
FROM dbo.FactTicketSales f
WHERE DimTicketTypeId IN (8) 

/*
UPDATE f
SET f.IsPremium = 1
FROM dbo.FactTicketSales f
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode <> 'GA'


UPDATE f
SET f.IsPremium = 0
FROM dbo.FactTicketSales f
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode = 'GA'
*/


UPDATE f
SET f.IsRenewal = 1
FROM dbo.FactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.DimPlanTypeID = 2


UPDATE f
SET f.IsRenewal = 0
FROM dbo.FactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.DimPlanTypeID <> 2




	

END


















































GO
