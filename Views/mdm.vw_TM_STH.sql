SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [mdm].[vw_TM_STH] AS

-------------------------------------------------------------------------------

-- Modification History --
-- 2018-07-03 Kaitlyn Nelson
-- Change notes: Updated Suite flag logic to only include plan holders, not single game suite rentals

-- Peer reviewed by: Keegan Schmitt
-- Peer review notes:Looks good
-- Peer review date:2018-7-5

-- Deployed by:
-- Deployment date:
-- Deployment notes:

-------------------------------------------------------------------------------

(
SELECT dc.dimcustomerid, STH, MPH, Suite, Grp, maxPurchaseDate, dc.accountid
FROM dbo.dimcustomer dc
LEFT JOIN (
	SELECT DISTINCT dimcustomerid, 1 AS 'STH' FROM dbo.factticketsales a
	LEFT JOIN dbo.dimdate dd ON a.DimDateId_OrigSale = dd.DimDateId
	WHERE a.DimTicketTypeId IN (1,2,3) AND dd.CalDate >= (GETDATE()-730)) sth ON dc.dimcustomerid = sth.dimcustomerid

LEFT JOIN (
	SELECT DISTINCT dimcustomerid, 1 AS 'MPH' FROM dbo.factticketsales a
	LEFT JOIN dbo.dimdate dd ON a.DimDateId_OrigSale = dd.DimDateId
	WHERE a.DimTicketTypeId IN (4,5,6,10,11) AND dd.CalDate > (GETDATE()-730)) mph ON dc.dimcustomerid = mph.dimcustomerid
LEFT JOIN (
	SELECT DISTINCT dimcustomerid, 1 AS 'Suite' FROM dbo.factticketsales a
	LEFT JOIN dbo.dimdate dd ON a.DimDateId_OrigSale = dd.DimDateId
	WHERE a.DimTicketTypeId IN (12, 14) AND dd.CalDate > (GETDATE()-730)) suite ON dc.dimcustomerid = suite.dimcustomerid
LEFT JOIN (
	SELECT DISTINCT dimcustomerid, 1 AS 'Grp' FROM dbo.factticketsales a
	LEFT JOIN dbo.dimdate dd ON a.DimDateId_OrigSale = dd.DimDateId
	WHERE a.DimTicketTypeId IN (7) AND dd.caldate >= (GETDATE()-730)) grp ON dc.dimcustomerid = grp.dimcustomerid
LEFT JOIN (
	SELECT dimcustomerid, MAX(maxtransdate) maxPurchaseDate 
	FROM (
		SELECT f.DimCustomerID, MAX(dd.CalDate) MaxTransDate , 'Predators-TM' Team
		--Select * 
		FROM dbo.FactTicketSales f WITH(NOLOCK)
		INNER JOIN dbo.DimDate  dd WITH(NOLOCK) ON dd.DimDateId = f.DimDateId
		WHERE dd.CalDate >= (GETDATE() - 730)
		GROUP BY f.[DimCustomerId]

		UNION ALL 

		SELECT f.DimCustomerID, MAX(dd.CalDate) MaxTransDate , 'Predators-TM' Team
		--Select * 
		FROM dbo.FactTicketSaleshistory f WITH(NOLOCK)
		INNER JOIN dbo.DimDate  dd WITH(NOLOCK) ON dd.DimDateId = f.DimDateId
		WHERE dd.CalDate >= (GETDATE() - 730)
		GROUP BY f.[DimCustomerId]

		UNION ALL
		SELECT dc.dimcustomerid, MAX(tex.add_datetime) MaxTransDate, 'Predators-TM' Team
		FROM Predators.ods.TM_Tex tex WITH (NOLOCK)
		LEFT JOIN Predators.dbo.dimcustomer dc WITH (NOLOCK) ON tex.assoc_acct_id = dc.accountid AND dc.customertype = 'Primary' AND dc.sourcesystem = 'TM'
		WHERE tex.add_datetime >= (GETDATE() - 730)
		GROUP BY dc.dimcustomerid
		) x
		GROUP BY x.dimcustomerid, x.team
	) purchasedate ON purchasedate.DimCustomerId = dc.DimCustomerId

	WHERE sth.STH IS NOT NULL
)

GO
