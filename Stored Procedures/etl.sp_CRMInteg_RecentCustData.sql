SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[sp_CRMInteg_RecentCustData]
AS
-- Truncate Table etl.SFDCProcess_RecentCustData 
--INSERT INTO etl.SFDCProcess_RecentCustData (SSID, MaxTransDate, Team)
--SELECT CAST(a.SSID AS VARCHAR(100)) SSID, MAX([SSUpdatedDate]) MaxTransDate,'Coyotes-TM' Team
--FROM coyotes.dbo.dimCustomer a 
--WHERE a.SourceSystem='TM'
--GROUP BY a.SSID

TRUNCATE TABLE etl.CRMProcess_RecentCustData

DECLARE @Client VARCHAR(50)
SET @Client = 'Predators'


--SELECT * FROM dbo.DimSeason WHERE DimSeasonId = 63

SELECT x.dimcustomerid, MAX(x.maxtransdate) maxtransdate, x.team
INTO #tmpTicketSales
	FROM (
		SELECT f.DimCustomerID, MAX(dd.CalDate) MaxTransDate , 'Predators-TM' Team
		--INTO #tmp
		FROM dbo.FactTicketSales f WITH(NOLOCK)
		INNER JOIN dbo.DimDate  dd WITH(NOLOCK) ON dd.DimDateId = f.DimDateId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = f.DimSeasonId
		WHERE dd.CalDate >= DATEADD(YEAR, -2, GETDATE()+2)
		AND (ds.SeasonName LIKE 'GA Hockey %'
			OR ds.SeasonName LIKE 'Predators 20% Season'
			OR ds.SeasonName LIKE 'Premium Seats 20%'
			OR ds.SeasonName LIKE '% All Star')
		GROUP BY f.[DimCustomerId]



		UNION ALL 

		SELECT f.DimCustomerID, MAX(dd.CalDate) MaxTransDate , 'Predators-TM' Team
		--Select * 
		FROM dbo.FactTicketSaleshistory f WITH(NOLOCK)
		INNER JOIN dbo.DimDate  dd WITH(NOLOCK) ON dd.DimDateId = f.DimDateId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = f.DimSeasonId
		WHERE dd.CalDate >= DATEADD(YEAR, -2, GETDATE()+2)
		AND ds.SeasonName IN (
			 'GA Hockey 2014'
			,'GA Hockey 2015'
			,'GA Hockey 2016'
			,'Predators 2014-2015 Season'
			,'Predators 2015-2016 Season'
			,'Predators 2016-2017 Season'
			,'Premium Seats 2014-2015'
			,'Premium Seats 2015-2016'
			,'Premium Seats 2016-2017'
			,'Predators 2017-2018 Season'
			,'2016 All Star')
		GROUP BY f.[DimCustomerId]

		UNION ALL
		SELECT dc.dimcustomerid, MAX(tex.add_datetime) MaxTransDate, 'Predators-TM' Team
		FROM Predators.ods.TM_Tex tex with (nolock)
		LEFT JOIN Predators.dbo.dimcustomer dc with (nolock) ON tex.assoc_acct_id = dc.accountid AND dc.customertype = 'Primary' AND dc.sourcesystem = 'TM'
		WHERE tex.add_datetime >= DATEADD(YEAR, -2, GETDATE()+2)
		AND Season_Name IN (
			 'GA Hockey 2014'
			,'GA Hockey 2015'
			,'GA Hockey 2016'
			,'Predators 2014-2015 Season'
			,'Predators 2015-2016 Season'
			,'Predators 2016-2017 Season'
			,'Premium Seats 2014-2015'
			,'Premium Seats 2015-2016'
			,'Premium Seats 2016-2017'
			,'Predators 2017-2018 Season'
			,'2016 All Star')
		GROUP BY dc.dimcustomerid
		) x
		GROUP BY x.dimcustomerid, x.team


INSERT INTO etl.CRMProcess_RecentCustData (SSID, MaxTransDate, Team)
SELECT SSID, [MaxTransDate], Team FROM [#tmpTicketSales] a 
INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[DimCustomerId] = [a].[DimCustomerId]



/*

SELECT b.DimCustomerId, MAX(b.UpdatedDate) Max_MDM_Date, 'Coyotes-TM' Team
INTO #tmpSFDC_Sourced
FROM ProdCopy.Account a WITH(NOLOCK)
INNER JOIN dbo.DimCustomer b WITH(NOLOCK) ON a.archtics_ID__c = CAST(b.AccountId AS NVARCHAR(20)) AND b.SourceSystem = 'TM'
WHERE Archtics_ID__c IS NOT NULL 
GROUP BY b.DimCustomerId
-- DROP TABLE #tmpSFDC_Sourced

SELECT b.DimCustomerId, MAX(a.InsertDate) MaxCDate, 'Coyotes-TM' Team
INTO #tmpNote_Sourced
FROM (
SELECT acct_id,InsertDate FROM ods.tm_note WITH (NOLOCK) WHERE task_stage_status = 'open'
) a
INNER JOIN dbo.DimCustomer b WITH(NOLOCK) ON a.acct_id = b.AccountId AND b.SourceSystem = 'TM'
GROUP BY b.DimCustomerId

SELECT b.DimCustomerId, MAX(Event_Date) MaxEventDate, 'Coyotes-TM' Team
INTO #tmpTE_Sourced
FROM (
SELECT Buyer_Archtics_ID, Event_Date FROM ods.vw_SFDC_Ticket_Exchange WITH(NOLOCK)
) a
INNER JOIN dbo.DimCustomer b WITH(NOLOCK) ON a.Buyer_Archtics_ID = b.AccountId AND b.SourceSystem = 'TM'
GROUP BY b.DimCustomerId
-- DROP TABLE #tmpTE_Sourced

SELECT b.DimCustomerId, MAX(LoadDate) MaxEventDate, 'Coyotes-TM' Team
INTO #tmpTemp_Srcd
FROM (
SELECT Temporary_Archtics_ID__c, LoadDate FROM Raiders_SFDC.stg.TempArchticsIDs WITH(NOLOCK) WHERE Archtics_ID__c IS NULL
) a
INNER JOIN dbo.DimCustomer b WITH(NOLOCK) ON a.Temporary_Archtics_ID__c = b.AccountId AND b.SourceSystem = 'TM'
GROUP BY b.DimCustomerId
-- DROP TABLE #tmpTE_Sourced
*/
-- 267,484
-- 264,541


GO
