SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_AggregatedSales]
AS


/*===========================================================================================================
	Insert/Update Composite Record data
===========================================================================================================*/
BEGIN
	MERGE etl.AggregatedSales AS TARGET
	USING
		(
			SELECT DISTINCT cr.SSB_CRMSYSTEM_CONTACT_ID
				, cr.FirstName
				, cr.LastName
				, cr.EmailPrimary
				, cr.PhonePrimary
				, cr.AddressPrimaryStreet
				, cr.AddressPrimaryCity
				, cr.AddressPrimaryState
				, cr.AddressPrimaryZip
				, s.SeasonName
			FROM mdm.CompositeRecord cr (NOLOCK)
			JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
				ON cr.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
			JOIN dbo.FactTicketSales f (NOLOCK)
				ON ssbid.DimCustomerId = f.DimCustomerId
			JOIN dbo.DimSeason s (NOLOCK)
				ON f.DimSeasonId = s.DimSeasonId
		) AS SOURCE
	ON (
		TARGET.SSB_CRMSYSTEM_CONTACT_ID = SOURCE.SSB_CRMSYSTEM_CONTACT_ID
		AND TARGET.Season = SOURCE.SeasonName
		)
	WHEN MATCHED AND (TARGET.FirstName <> SOURCE.FirstName
					OR TARGET.LastName <> SOURCE.LastName
					OR TARGET.Email <> SOURCE.EmailPrimary
					OR TARGET.Phone <> SOURCE.PhonePrimary
					)
	THEN
		UPDATE SET
			  TARGET.FirstName = SOURCE.FirstName
			, TARGET.LastName = SOURCE.LastName
			, TARGET.Email = SOURCE.EmailPrimary
			, TARGET.Phone = SOURCE.PhonePrimary
			, TARGET.ETL_UpdatedDate = GETDATE()

	WHEN NOT MATCHED THEN
	INSERT (SSB_CRMSYSTEM_CONTACT_ID, FirstName, LastName, Email, Phone, Season, ETL_UpdatedDate)

	VALUES (
		  SOURCE.SSB_CRMSYSTEM_CONTACT_ID
		, SOURCE.FirstName
		, SOURCE.LastName
		, SOURCE.EmailPrimary
		, SOURCE.PhonePrimary
		, SOURCE.SeasonName
		, GETDATE()
		)
	;
END

/*===========================================================================================================
	Delete Composite Record IDs that no longer exist
===========================================================================================================*/
DELETE
FROM etl.AggregatedSales
WHERE SSB_CRMSYSTEM_CONTACT_ID NOT IN (
		SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID FROM mdm.CompositeRecord
		);


/*===========================================================================================================
	Update Archtics IDs
===========================================================================================================*/
SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, CAST(dc.AccountId AS NVARCHAR(50)) AccountID
INTO #ArchticsIDs
FROM dbo.DimCustomer dc (NOLOCK)
JOIN dbo.DimCustomerSSBID ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
	AND dc.CustomerType = 'Primary'


UPDATE a
SET a.ArchticsIDs = d.ArchticsIds
FROM etl.AggregatedSales a
JOIN (
	SELECT DISTINCT b.SSB_CRMSYSTEM_CONTACT_ID, 
		SUBSTRING(
			(
				SELECT ','+ a.AccountId  AS [text()]
				FROM #ArchticsIDs a
				WHERE a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
				ORDER BY a.SSB_CRMSYSTEM_CONTACT_ID
				FOR XML PATH ('')
			), 2, 1000) [ArchticsIDs]
	FROM #ArchticsIDs b
	) d ON a.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID




/*===========================================================================================================
	Update Full Season Ticket Qty
===========================================================================================================*/
UPDATE a
SET a.FullSeasonTotalQty = b.Qty
FROM etl.AggregatedSales a
JOIN (
	SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName, SUM(f.QtySeat) Qty
	FROM dbo.FactTicketSales f (NOLOCK)
	JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
		ON f.DimCustomerId = ssbid.DimCustomerId
	JOIN dbo.dimevent e (NOLOCK)
		ON f.DimEventId = e.DimEventId
	JOIN dbo.dimseason s (NOLOCK)
		ON f.DimSeasonId = s.DimSeasonId
	WHERE f.DimTicketTypeId = 1
	AND e.EventCode IN ('70404NYI','80407CBJ')
	GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName
	) b ON b.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID AND b.SeasonName = a.Season



/*===========================================================================================================
	Update Full Season Total Ticket Qty
===========================================================================================================*/
UPDATE a
SET a.FullSeasonTotalQty = b.Qty
FROM etl.AggregatedSales a
JOIN (
	SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName, SUM(f.QtySeat) Qty
	FROM dbo.FactTicketSales f (NOLOCK)
	JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
		ON f.DimCustomerId = ssbid.DimCustomerId
	JOIN dbo.DimSeason s (NOLOCK)
		ON f.DimSeasonId = s.DimSeasonId
	WHERE f.DimTicketTypeId = 1
	GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName
	) b ON b.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID AND b.SeasonName = a.Season



/*===========================================================================================================
	Update Full Season Total Revenue
===========================================================================================================*/
UPDATE a
SET a.FullSeasonRevenue = b.Revenue
FROM etl.AggregatedSales a
JOIN (
	SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName, SUM(f.TotalRevenue) Revenue
	FROM dbo.FactTicketSales f (NOLOCK)
	JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
		ON f.DimCustomerId = ssbid.DimCustomerId
	JOIN dbo.DimSeason s (NOLOCK)
		ON f.DimSeasonId = s.DimSeasonId
	WHERE f.DimTicketTypeId = 1
	GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName
	) b ON b.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID AND b.SeasonName = a.Season



/*===========================================================================================================
	Update Full Season Plan Codes
===========================================================================================================*/
SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName, p.PlanCode
INTO #FSPlanCodes
FROM dbo.DimCustomer dc (NOLOCK)
JOIN dbo.DimCustomerSSBID ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
JOIN dbo.FactTicketSales f (NOLOCK)
	ON dc.DimCustomerId = f.DimCustomerId
JOIN dbo.DimSeason s (NOLOCK)
	ON f.DimSeasonId = f.DimSeasonId
JOIN dbo.DimPlan p (NOLOCK)
	ON p.DimPlanId = f.DimPlanId
WHERE f.DimTicketTypeId = 1


UPDATE a
SET a.FullSeasonPlanCodes = d.PlanCodes
FROM etl.AggregatedSales a
JOIN (
	SELECT DISTINCT b.SSB_CRMSYSTEM_CONTACT_ID, b.SeasonName,
		SUBSTRING(
			(
				SELECT ','+ a.PlanCode AS [text()]
				FROM #FSPlanCodes a
				WHERE a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
					AND a.SeasonName = b.SeasonName
				ORDER BY a.SSB_CRMSYSTEM_CONTACT_ID
				FOR XML PATH ('')
			), 2, 1000) [PlanCodes]
	FROM #FSPlanCodes b
	) d ON a.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
		AND a.Season = d.SeasonName


/*===========================================================================================================
	Update Half Season Plan Codes
===========================================================================================================*/
SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName, p.PlanCode
INTO #HSPlanCodes
FROM dbo.DimCustomer dc (NOLOCK)
JOIN dbo.DimCustomerSSBID ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
JOIN dbo.FactTicketSales f (NOLOCK)
	ON dc.DimCustomerId = f.DimCustomerId
JOIN dbo.DimSeason s (NOLOCK)
	ON f.DimSeasonId = f.DimSeasonId
JOIN dbo.DimPlan p (NOLOCK)
	ON p.DimPlanId = f.DimPlanId
WHERE f.DimTicketTypeId IN (2, 3, 12, 13)


UPDATE a
SET a.HalfSeasonPlanCodes = d.PlanCodes
FROM etl.AggregatedSales a
JOIN (
	SELECT DISTINCT b.SSB_CRMSYSTEM_CONTACT_ID, b.SeasonName,
		SUBSTRING(
			(
				SELECT ','+ a.PlanCode AS [text()]
				FROM #HSPlanCodes a
				WHERE a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
					AND a.SeasonName = b.SeasonName
				ORDER BY a.SSB_CRMSYSTEM_CONTACT_ID
				FOR XML PATH ('')
			), 2, 1000) [PlanCodes]
	FROM #HSPlanCodes b
	) d ON a.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
		AND a.Season = d.SeasonName


/*===========================================================================================================
	Update Partial Season Plan Codes
===========================================================================================================*/
SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName, p.PlanCode
INTO #PSPlanCodes
FROM dbo.DimCustomer dc (NOLOCK)
JOIN dbo.DimCustomerSSBID ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
JOIN dbo.FactTicketSales f (NOLOCK)
	ON dc.DimCustomerId = f.DimCustomerId
JOIN dbo.DimSeason s (NOLOCK)
	ON f.DimSeasonId = f.DimSeasonId
JOIN dbo.DimPlan p (NOLOCK)
	ON p.DimPlanId = f.DimPlanId
WHERE f.DimTicketTypeId IN (4, 5, 6, 10, 11)


UPDATE a
SET a.PartialSeasonPlanCodes = d.PlanCodes
FROM etl.AggregatedSales a
JOIN (
	SELECT DISTINCT b.SSB_CRMSYSTEM_CONTACT_ID, b.SeasonName,
		SUBSTRING(
			(
				SELECT ','+ a.PlanCode AS [text()]
				FROM #PSPlanCodes a
				WHERE a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
					AND a.SeasonName = b.SeasonName
				ORDER BY a.SSB_CRMSYSTEM_CONTACT_ID
				FOR XML PATH ('')
			), 2, 1000) [PlanCodes]
	FROM #PSPlanCodes b
	) d ON a.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
		AND a.Season = d.SeasonName



/*===========================================================================================================
	Update Other Plan Codes
===========================================================================================================*/
SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, s.SeasonName, p.PlanCode
INTO #OtherPlanCodes
FROM dbo.DimCustomer dc (NOLOCK)
JOIN dbo.DimCustomerSSBID ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
JOIN dbo.FactTicketSales f (NOLOCK)
	ON dc.DimCustomerId = f.DimCustomerId
JOIN dbo.DimSeason s (NOLOCK)
	ON f.DimSeasonId = f.DimSeasonId
JOIN dbo.DimPlan p (NOLOCK)
	ON p.DimPlanId = f.DimPlanId
WHERE f.DimTicketTypeId IN (7,8)


UPDATE a
SET a.OtherSeasonPlanCodes = d.PlanCodes
FROM etl.AggregatedSales a
JOIN (
	SELECT DISTINCT b.SSB_CRMSYSTEM_CONTACT_ID, b.SeasonName,
		SUBSTRING(
			(
				SELECT ','+ a.PlanCode AS [text()]
				FROM #OtherPlanCodes a
				WHERE a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
					AND a.SeasonName = b.SeasonName
				ORDER BY a.SSB_CRMSYSTEM_CONTACT_ID
				FOR XML PATH ('')
			), 2, 1000) [PlanCodes]
	FROM #OtherPlanCodes b
	) d ON a.SSB_CRMSYSTEM_CONTACT_ID = d.SSB_CRMSYSTEM_CONTACT_ID
		AND a.Season = d.SeasonName



GO
