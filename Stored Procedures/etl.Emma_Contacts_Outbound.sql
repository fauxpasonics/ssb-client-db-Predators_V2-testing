SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
 
CREATE PROCEDURE [etl].[Emma_Contacts_Outbound] 
 
AS

-------------------------------------------------------------------------------

-- Author name:		Keegan Schmitt
-- Created date:	2018-06-11
-- Purpose:			Prep custom field data for Predators Emma outbound integration

-- Copyright © 2018, SSB, All Rights Reserved

-------------------------------------------------------------------------------

-- Modification History --

-- 2018-06-11:		Keegan Schmitt
-- Change notes:	Created

-- Peer reviewed by:	Kaitlyn Nelson
-- Peer review notes:	Streamlined a little, I removed all the temp tables used to
--						update the stage table and set up statements to update
--						the ods table directly.
-- Peer review date:	2018-06-19

-- Deployed by:
-- Deployment date:
-- Deployment notes:

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

BEGIN


-- Deleted old staged records (that should have been created) --
DELETE
FROM ods.Emma_Contacts_Outbound
WHERE MemberID IS NULL


-- Stage brand new Emma contacts --
INSERT INTO ods.Emma_Contacts_Outbound (AccountID, MemberID, ArchticsID, Email
	, SSB_CRMSYSTEM_CONTACT_ID--, CompanyName, Phone, SecondaryEmail, AccountRepName
	--, AccountRepEmail, AccountRepPhone, SSBBulldog, SSBSeasonTicketHolder
	--, SSBPartialPlanBuyer, SSBClubTicketBuyer, SSBSuiteTicketBuyer, SSBGroupTicketBuyer
	--, SSBSingleGameTicketBuyer, SSBParkingBuyer, SSBMostRecentEvent, SSBNextEvent
	--, SSBSeatLocation, SSBSeatQty, SSBTMSinceDate
	)

SELECT em.AccountID, em.MemberID, em.ArchticsID, em.Email
	, ssbid.SSB_CRMSYSTEM_CONTACT_ID--, dc.CompanyName, Phone, SecondaryEmail, AccountRepName
	--, AccountRepEmail, AccountRepPhone, SSBBulldog, SSBSeasonTicketHolder
	--, SSBPartialPlanBuyer, SSBClubTicketBuyer, SSBSuiteTicketBuyer, SSBGroupTicketBuyer
	--, SSBSingleGameTicketBuyer, SSBParkingBuyer, SSBMostRecentEvent, SSBNextEvent
	--, SSBSeatLocation, SSBSeatQty, SSBTMSinceDate
FROM ods.Emma_Members em (NOLOCK)
JOIN dbo.dimcustomer dc (NOLOCK)
	ON em.MemberID = dc.SSID
	AND em.Email = dc.EmailPrimary
JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
LEFT JOIN ods.Emma_Contacts_Outbound eco (NOLOCK)
	ON eco.AccountID = em.AccountID
	AND eco.MemberID = em.MemberID
	AND eco.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
WHERE eco.SSB_CRMSYSTEM_CONTACT_ID IS NULL



-- Stage records that need to be created in Emma --
DECLARE @SeasonYear INT = 2018

SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
INTO #STH
FROM dbo.FactTicketSales f (NOLOCK)
JOIN dbo.DimCustomerSSBID ssbid (NOLOCK)
	ON f.DimCustomerId = ssbid.DimCustomerId
JOIN dbo.dimseason s (NOLOCK)
	ON f.DimSeasonId = s.DimSeasonId
WHERE f.DimTicketTypeId IN (1, 14)
	AND s.SeasonYear = @SeasonYear
	AND s.SeasonClass <> 'Hockey Parking'

INSERT INTO ods.Emma_Contacts_Outbound (AccountID, MemberID, ArchticsID, Email, SSB_CRMSYSTEM_CONTACT_ID)

SELECT ea.AccountID, NULL, NULL, cr.EmailPrimary, cr.SSB_CRMSYSTEM_CONTACT_ID
FROM mdm.CompositeRecord cr (NOLOCK)
JOIN ods.Emma_Accounts ea (NOLOCK)
	ON ea.AccountID IN (1775920, 1740514, 1738317, 1735727, 1735101, 1729929, 1717380, 1734221, 1714928, 1720674)
JOIN #STH sth (NOLOCK)
	ON cr.SSB_CRMSYSTEM_CONTACT_ID = sth.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN (
		SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID, AccountID
		FROM ods.Emma_Contacts_Outbound (NOLOCK)
	) eoc ON eoc.AccountID = ea.AccountID
	AND eoc.SSB_CRMSYSTEM_CONTACT_ID = cr.SSB_CRMSYSTEM_CONTACT_ID
WHERE eoc.SSB_CRMSYSTEM_CONTACT_ID IS NULL
	AND cr.EmailPrimaryIsCleanStatus = 'Valid'
	AND cr.EmailPrimary NOT IN ('')
ORDER BY ea.AccountID



-- Set custom fields for staged Emma records 

-- STH Flag --
UPDATE a
SET a.SSBSeasonTicketHolder = CASE WHEN b.IsSTH = 1 THEN 'Yes' ELSE 'No' END
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, 1 AS IsSTH
		FROM dbo.FactTicketSales f (NOLOCK)
		JOIN dbo.DimCustomer dc (NOLOCK)
			ON f.DimCustomerId = dc.DimCustomerId
		JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
			ON dc.DimCustomerId = ssbid.DimCustomerId
		JOIN dbo.DimSeason s (NOLOCK)
			ON s.DimSeasonId = f.DimSeasonId
		WHERE s.SeasonClass <> 'Hockey Parking' AND s.SeasonYear = @SeasonYear
			AND f.DimTicketTypeId IN (1, 14)
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
 

-- Club Flag --
UPDATE a
SET a.SSBClubTicketBuyer = CASE WHEN b.IsClubBuyer = 1 THEN 'Yes' ELSE 'No' END
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, 1 AS IsClubBuyer
		FROM dbo.FactTicketSales f (NOLOCK)
		JOIN dbo.DimCustomer dc (NOLOCK)
			ON f.DimCustomerId = dc.DimCustomerId
		JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
			ON dc.DimCustomerId = ssbid.DimCustomerId
		JOIN dbo.DimSeason s (NOLOCK)
			ON s.DimSeasonId = f.DimSeasonId
		WHERE s.SeasonClass <> 'Hockey Parking' AND s.SeasonYear = @SeasonYear
			AND f.DimSeatTypeId IN (2, 8)
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
 

-- Suite Flag --
UPDATE a
SET a.SSBSuiteTicketBuyer = CASE WHEN b.IsSuiteBuyer = 1 THEN 'Yes' ELSE 'No' END
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, 1 AS IsSuiteBuyer
		FROM dbo.FactTicketSales f (NOLOCK)
		JOIN dbo.DimCustomer dc (NOLOCK)
			ON f.DimCustomerId = dc.DimCustomerId
		JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
			ON dc.DimCustomerId = ssbid.DimCustomerId
		JOIN dbo.DimSeason s (NOLOCK)
			ON s.DimSeasonId = f.DimSeasonId
		WHERE s.SeasonClass <> 'Hockey Parking' AND s.SeasonYear = @SeasonYear
			AND f.DimTicketTypeId IN (12, 14, 15)
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
 

-- Group Flag --
UPDATE a
SET a.SSBGroupTicketBuyer = CASE WHEN b.IsGroupBuyer = 1 THEN 'Yes' ELSE 'No' END
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, 1 AS IsGroupBuyer
		FROM dbo.FactTicketSales f (NOLOCK)
		JOIN dbo.DimCustomer dc (NOLOCK)
			ON f.DimCustomerId = dc.DimCustomerId
		JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
			ON dc.DimCustomerId = ssbid.DimCustomerId
		JOIN dbo.DimSeason s (NOLOCK)
			ON s.DimSeasonId = f.DimSeasonId
		WHERE s.SeasonClass <> 'Hockey Parking' AND s.SeasonYear = @SeasonYear
			AND f.DimTicketTypeId IN (7)
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID

 
-- Single Game Flag --
UPDATE a
SET a.SSBSingleGameTicketBuyer = CASE WHEN b.IsSGBuyer = 1 THEN 'Yes' ELSE 'No' END
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, 1 AS IsSGBuyer
		FROM dbo.FactTicketSales f (NOLOCK)
		JOIN dbo.DimCustomer dc (NOLOCK)
			ON f.DimCustomerId = dc.DimCustomerId
		JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
			ON dc.DimCustomerId = ssbid.DimCustomerId
		JOIN dbo.DimSeason s (NOLOCK)
			ON s.DimSeasonId = f.DimSeasonId
		WHERE s.SeasonClass <> 'Hockey Parking' AND s.SeasonYear = @SeasonYear
			AND f.DimTicketTypeId IN (8)
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID


-- Parking Buyers -- 
UPDATE a
SET a.SSBParkingBuyer = CASE WHEN b.IsParkingBuyer = 1 THEN 'Yes' ELSE 'No' END
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, 1 AS IsParkingBuyer
		FROM dbo.FactTicketSales f (NOLOCK)
		JOIN dbo.DimCustomer dc (NOLOCK)
			ON f.DimCustomerId = dc.DimCustomerId
		JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
			ON dc.DimCustomerId = ssbid.DimCustomerId
		JOIN dbo.DimSeason s (NOLOCK)
			ON s.DimSeasonId = f.DimSeasonId
		WHERE s.SeasonClass = 'Hockey Parking' AND s.SeasonYear = @SeasonYear
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID

 
-- Partial Plan Buyers --
UPDATE a
SET a.SSBPartialPlanBuyer = CASE WHEN b.IsPartialBuyer = 1 THEN 'Yes' ELSE 'No' END
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID, 1 AS IsPartialBuyer
		FROM dbo.FactTicketSales f (NOLOCK)
		JOIN dbo.DimCustomer dc (NOLOCK)
			ON f.DimCustomerId = dc.DimCustomerId
		JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
			ON dc.DimCustomerId = ssbid.DimCustomerId
		JOIN dbo.DimSeason s (NOLOCK)
			ON s.DimSeasonId = f.DimSeasonId
		WHERE s.SeasonClass <> 'Hockey Parking' AND s.SeasonYear = @SeasonYear
			AND f.DimTicketTypeId IN (2, 3, 4, 5, 6, 11)
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID


 
-- Bulldogs --
UPDATE a
SET a.SSBBulldog = CASE WHEN ISNULL(dc.AccountType, '') = 'BULLDOGS' THEN 'Yes' ELSE 'No' END
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
	ON a.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
JOIN dbo.dimcustomer dc (NOLOCK)
	ON ssbid.DimCustomerId = dc.DimCustomerId

 

-- Next Game --
IF OBJECT_ID('tempdb..#NextGame') IS NOT NULL DROP TABLE #NextGame
IF OBJECT_ID('tempdb..#NumSeats') IS NOT NULL DROP TABLE #NumSeats

SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, e.DimEventId, e.EventCode, e.EventDate, e.EventTime
	, st.SectionName, st.RowName, st.Seat
	, RANK() OVER(PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
		ORDER BY e.EventDateTime, st.SectionName, st.RowName, st.Seat) xRank
INTO #NextGame
FROM dbo.FactTicketSales f (NOLOCK)
JOIN dbo.DimEvent e (NOLOCK)
	ON f.DimEventId = e.DimEventId
JOIN dbo.DimCustomer dc (NOLOCK)
	ON f.DimCustomerId = dc.DimCustomerId
JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
JOIN dbo.dimseat st (NOLOCK)
	ON f.DimSeatIdStart = st.DimSeatId
JOIN dbo.DimSeason s (NOLOCK)
	ON f.DimSeasonId = s.DimSeasonId
WHERE e.EventDate >= CAST(GETDATE() AS DATE)
	AND s.SeasonClass  <> 'Hockey Parking'
	AND e.EventCode NOT LIKE 'PP%'

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, e.DimEventId
	, SUM(f.QtySeat) QtySeat
INTO #NumSeats
FROM dbo.FactTicketSales f (NOLOCK)
JOIN dbo.DimEvent e (NOLOCK)
	ON f.DimEventId = e.DimEventId
JOIN dbo.DimCustomer dc (NOLOCK)
	ON f.DimCustomerId = dc.DimCustomerId
JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
WHERE e.EventDate >= CAST(GETDATE() AS DATE)
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, e.DimEventId

UPDATE a
SET a.SSBNextEvent = b.EventCode
	, a.SSBSeatLocation = b.SeatLocation
	, a.SSBSeatQty = b.QtySeat
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT ng.SSB_CRMSYSTEM_CONTACT_ID
			, ng.EventCode
			, CONCAT('Section ', ng.SectionName, ', Row ', ng.RowName, ', Seats ', ng.Seat, '-', (ng.Seat + ns.QtySeat - 1)) SeatLocation
			, ns.QtySeat
		FROM #NextGame ng (NOLOCK)
		JOIN #NumSeats ns (NOLOCK)
			ON ng.SSB_CRMSYSTEM_CONTACT_ID = ns.SSB_CRMSYSTEM_CONTACT_ID
			AND ng.DimEventId = ns.DimEventId
		WHERE ng.xRank = 1
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID


 
-- Most Recent Game --
IF OBJECT_ID('tempdb..#MostRecentGame') IS NOT NULL DROP TABLE #MostRecentGame
 
SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, e.EventCode, e.EventDateTime, f.ScanDateTime
	, RANK() OVER(PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
		ORDER BY f.ScanDateTime DESC) xRank
INTO #MostRecentGame
FROM dbo.FactAttendance f (NOLOCK)
JOIN dbo.DimEvent e (NOLOCK)
	ON f.DimEventId = e.DimEventId
JOIN dbo.DimCustomer dc (NOLOCK)
	ON f.DimCustomerId = dc.DimCustomerId
JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
	ON dc.DimCustomerId = ssbid.DimCustomerId
JOIN dbo.DimSeason s (NOLOCK)
	ON e.DimSeasonId = s.DimSeasonId
WHERE e.EventDate <= CAST(GETDATE() AS DATE)
	AND s.SeasonClass  <> 'Hockey Parking'
	AND e.EventCode NOT LIKE 'PP%'

UPDATE a
SET a.SSBMostRecentEvent = b.EventCode
FROM ods.Emma_Contacts_Outbound a (NOLOCK)
LEFT JOIN (
		SELECT SSB_CRMSYSTEM_CONTACT_ID, EventCode
		FROM #MostRecentGame
		WHERE xRank = 1
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID



-- TM Since Date, Archtics IDs --
UPDATE a
SET a.SSBTMSinceDate = b.Since_date
	, a.ArchticsID = b.acct_id
FROM ods.Emma_Contacts_Outbound a
LEFT JOIN (
		SELECT pfrk.SSB_CRMSYSTEM_CONTACT_ID, tmc.Since_date, tmc.acct_id
		FROM mdm.PrimaryFlagRanking_Contact pfrk (NOLOCK)
		JOIN ods.TM_Cust tmc (NOLOCK)
			ON pfrk.ssid = CONCAT(tmc.acct_id, ':', tmc.cust_name_id)
		WHERE pfrk.ss_ranking = 1
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID

-- Account Rep Name, Email, Phone --
UPDATE a
SET a.AccountRepName = b.rep_full_name
	, a.AccountRepEmail = b.rep_email_addr
	, a.AccountRepPhone = b.rep_phone
FROM ods.Emma_Contacts_Outbound a
LEFT JOIN (
		SELECT pfrk.SSB_CRMSYSTEM_CONTACT_ID, tmcr.rep_full_name
			, tmcr.rep_email_addr, tmcr.rep_phone
		FROM mdm.PrimaryFlagRanking_Contact pfrk (NOLOCK)
		JOIN dbo.dimcustomer dc (NOLOCK)
			ON pfrk.ssid = dc.SSID
			AND pfrk.sourcesystem = dc.SourceSystem
			AND dc.CustomerType = 'Primary'
		JOIN ods.TM_CustRep tmcr (NOLOCK)
			ON dc.AccountId = tmcr.acct_id
		WHERE pfrk.ss_ranking = 1
	) b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID


-- Company Name, Phone --
UPDATE a
SET a.CompanyName = cr.CompanyName
	, a.Phone = cr.PhonePrimary
FROM ods.Emma_Contacts_Outbound a
JOIN mdm.CompositeRecord cr (NOLOCK)
	ON a.SSB_CRMSYSTEM_CONTACT_ID = cr.SSB_CRMSYSTEM_CONTACT_ID


-- Secondary Email --
UPDATE a
SET a.SecondaryEmail = CASE WHEN cr.EmailPrimary = a.Email THEN COALESCE(cr.EmailOne, cr.EmailTwo, cr.EmailPrimary)
						ELSE COALESCE(cr.EmailPrimary, cr.EmailOne, cr.EmailTwo) END
FROM ods.Emma_Contacts_Outbound a
JOIN mdm.CompositeRecord cr (NOLOCK)
	ON a.SSB_CRMSYSTEM_CONTACT_ID = cr.SSB_CRMSYSTEM_CONTACT_ID






/*
 
IF OBJECT_ID('tempdb..#Stage') IS NOT NULL DROP TABLE #Stage
 
SELECT DISTINCT
	  e.accountid   
	, e.MemberID  AS [Account Number]
	, f.acct_id
	, e.Email
	, e.SSB_CRMSYSTEM_CONTACT_ID  AS SSB_CRMSYSTEM_CONTACT_ID
	, f.AccountRep AS [Ticket Level Account Rep]
	, CASE WHEN f.dimtickettypeID IN (1,14) THEN f.pricecode ELSE NULL END AS [Season Ticket Price Code] -- factticketsales dimpricecode
	, CASE WHEN sth.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END AS STH
	, f.seasonyear
	, f.acct_type_desc AS [Account Type] -- tm_cust accountID to]
	, CASE WHEN sb.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END AS SuiteBuyer_Flag
	, CASE WHEN cb.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END AS ClubBuyer_Flag
	, CASE WHEN gb.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END AS GroupBuyer_Flag
	, CASE WHEN pp.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END AS PartialPlan_Flag
	, CASE WHEN sgb.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END AS SGB
	--, CASE WHEN prk.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END AS ParkingFlag
	, CASE WHEN bd.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END AS Bulldog_Flag
	, f.sectionname 
	, CONCAT(f.sectionname, ':', f.rowname, ':' ,f.seat)AS [Seat location] 
	, CASE WHEN sth.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN qty.qtyseatFSE ELSE qty.qtyseat END AS NumberofSeats
	, rg.RecentGame
	, ng.NextGame
	, f.since_date
	, ROW_NUMBER() OVER (PARTITION BY E.MemberID, f.acct_id ORDER BY f.PcTicketValue DESC, CONCAT(f.sectionname, ':', f.rowname, ':' ,f.seat) ASC, CASE WHEN sth.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1 ELSE 0 END ) AS PersonRank
--select count(*)
INTO  #stage
FROM #Emma E
LEFT JOIN #factticketSales f
    ON f.SSB_CRMSYSTEM_CONTACT_ID = e.SSB_CRMSYSTEM_CONTACT_ID AND f.EmailPrimary = e.email
LEFT JOIN #STH sth 
    ON sth.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND sth.EmailPrimary = e.email
LEFT JOIN #ClubBuyer cb
    ON cb.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND cb.EmailPrimary = e.email
LEFT JOIN #SuiteBuyer sb
    ON sb.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND sb.EmailPrimary = e.email
LEFT JOIN #GroupBuyer gb
    ON gb.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND gb.EmailPrimary = e.email
LEFT JOIN #PartialPLan pp
    ON pp.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND pp.EmailPrimary = e.email
LEFT JOIN #Bulldogs bd
    ON bd.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND bd.EmailPrimary = e.email
LEFT JOIN #RecentGame rg
    ON rg.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND rg.EmailPrimary = e.email
--LEFT JOIN #parking prk
--  ON prk.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND prk.EmailPrimary = e.email
LEFT JOIN #NextGame ng
    ON ng.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND ng.EmailPrimary = e.email
LEFT JOIN #singlegame sgb
    ON sgb.SSB_CRMSYSTEM_CONTACT_ID = E.SSB_CRMSYSTEM_CONTACT_ID AND sgb.EmailPrimary = e.email
LEFT JOIN #QTYSeat qty
    ON qty.SSB_CRMSYSTEM_CONTACT_ID = e.SSB_CRMSYSTEM_CONTACT_ID AND qty.EmailPrimary = e.email
 
 
 
    --SELECT [Account Number],COUNT(*) FROM #stage
    --WHERE PersonRank = 1
    --GROUP BY [Account Number]
    --HAVING COUNT(*) >1
 
    --SELECT * FROM #stage
    --WHERE [Account Number] = '952288576'
    --AND PersonRank = 1
 
 
    --SELECT EmailPrimary, * FROM dbo.vwDimCustomer_ModAcctId WHERE SSB_CRMSYSTEM_CONTACT_ID = '67608FF0-49B8-4E1B-BFBC-ABB720FD72CF'
 
 
MERGE ods.Emma_Contacts_Outbound AS TARGET
USING (
		SELECT AccountID
			, [Account Number]
			, acct_id
			, SSB_CRMSYSTEM_CONTACT_ID
			, email
			, [Ticket Level Account Rep]  -- Remove NULL once source values are populated
			, STH
			, SeasonYear
			, [Account Type]
			, SuiteBuyer_Flag
			, ClubBuyer_Flag
			, GroupBuyer_Flag
			, PartialPlan_Flag
			, SGB
			, SectionName
			, [Seat location]
			, NumberofSeats
			, Since_date
			, NULL ParkingFlag 
			, NextGame
			, RecentGame
		FROM #stage WHERE PersonRank=1
	) AS SOURCE
        ON SOURCE.[Account Number] = TARGET.[Account Number]
		AND SOURCE.acct_id = TARGET.acct_id 

WHEN MATCHED THEN

UPDATE SET
	  TARGET.accountid = SOURCE.AccountID
	, TARGET.[Account Number] = SOURCE.[Account Number]
	, TARGET.SSB_CRMSYSTEM_CONTACT_ID = SOURCE.SSB_CRMSYSTEM_CONTACT_ID
	, TARGET.acct_ID = SOURCE.acct_id
	, TARGET.email = SOURCE.email
	, TARGET.[Ticket Level Account Rep] = SOURCE.[Ticket Level Account Rep]
	, TARGET.[Season Ticket Price Code] = SOURCE.[Season Ticket Price Code]
	, TARGET.STH = SOURCE.STH
	, TARGET.SeasonYear = SOURCE.SeasonYear
	, TARGET.[Account Type] = SOURCE.[Account Type]
	, TARGET.RecentGame = SOURCE.RecentGame
	, TARGET.NextGame = SOURCE.NextGame
	, TARGET.sectionname = SOURCE.sectionname
	, TARGET.[Seat location]= SOURCE.[Seat location]
	, TARGET.numberofseats= SOURCE.numberofseats
	, TARGET.ClubBuyer_Flag= SOURCE.ClubBuyer_Flag
	, TARGET.Since_date = SOURCE.Since_date
	, TARGET.SGB = SOURCE.SGB
	, TARGET.GroupBuyer_Flag=SOURCE.GroupBuyer_Flag
	--, TARGET.ParkingFlag = SOURCE.ParkingFlag
	, TARGET.PartialPlan_Flag = SOURCE.PartialPlan_Flag

WHEN NOT MATCHED THEN
	INSERT (
			  AccountID
			, [Account Number]
			, acct_id
			, SSB_CRMSYSTEM_CONTACT_ID
			, email
			, STH
			, SeasonYear
			, [Account Type]
			, SuiteBuyer_Flag
			, ClubBuyer_Flag
			, GroupBuyer_Flag
			, PartialPlan_Flag
			, SGB
			, SectionName
			, [Seat location]
			, NumberofSeats
			, Since_date
			, ParkingFlag 
			, NextGame
			, RecentGame
		)
VALUES (
			  SOURCE.AccountID
			, SOURCE.[Account Number]
			, SOURCE.acct_id
			, SOURCE.SSB_CRMSYSTEM_CONTACT_ID
			, SOURCE.email
			, SOURCE.[Ticket Level Account Rep]  -- Remove NULL once source values are populated
			, SOURCE.[Kids Club member name (Additional Info 6)]
			, SOURCE.[Kids club member birthday (Additional Info 7)]
			, SOURCE.[Kids Club Member 2 (Additional Info 9)]
			, SOURCE.[KC Member BDay 2 (Additional Info 10)]
			, SOURCE.[Kids Club Member 3 (Additional Info 11)]
			, SOURCE.[KC Member BDay 3 (Additional Info 12)]
			, SOURCE.[Season Ticket Price Code]
			, SOURCE.STH
			, SOURCE.SeasonYear
			, SOURCE.[Account Type]
			, SOURCE.SuiteBuyer_Flag
			, SOURCE.ClubBuyer_Flag
			, SOURCE.GroupBuyer_Flag
			, SOURCE.PartialPlan_Flag
			, SOURCE.SGB
			, SOURCE.SectionName
			, SOURCE.[Seat location]
			, SOURCE.NumberofSeats
			, SOURCE.Since_date
			, SOURCE.ParkingFlag 
			, SOURCE.NextGame
			, SOURCE.RecentGame
		);

END
 
 */

END

GO
