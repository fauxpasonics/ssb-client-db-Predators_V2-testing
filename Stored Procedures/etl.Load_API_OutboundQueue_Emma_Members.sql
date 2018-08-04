SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [etl].[Load_API_OutboundQueue_Emma_Members]
AS

--TRUNCATE TABLE ods.API_OutboundQueue

-- This prcoess needs to be run after the data is ynced to azure.  Ian's outbound process will run at any point after the sync and queue load is complete 

IF OBJECT_ID('tempdb..#Working') IS NOT NULL
	DROP TABLE #working
		
	CREATE TABLE #working --TABLE	 
		(SSID	VARCHAR(50)
		,GroupID INT
		,QueueID INT )

IF OBJECT_ID('tempdb..#tempQueue') IS NOT NULL
	DROP TABLE #tempQueue
		
	CREATE TABLE #tempQueue--TABLE	 
		([APIName] [VARCHAR](100) NOT NULL,
		[APIEntity] [VARCHAR](100) NOT NULL,
		[EndpointName] [VARCHAR](100) NOT NULL,
		[SourceID] [VARCHAR](100) NOT NULL,
		[MemberID] [VARCHAR](100) NOT NULL,
		[Json_Payload] [NVARCHAR](MAX) NOT NULL,
		[httpAction] [NVARCHAR](100) NOT NULL,
		[Description] [VARCHAR](MAX) NULL
		,GroupID INT
		,QueueInsertVal UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL)

--can change ceiling count to 1 if it needs to be sent over in single record firm and not bulk
DECLARE @groups BIGINT = (SELECT CEILING(COUNT(1) / 3000) FROM ods.Emma_Contacts_Outbound_Json_Payload)  --WHERE QueueID IS NULL)

INSERT INTO #working ( SSID, GroupID)

SELECT [MemberID], NTILE(@groups) OVER(ORDER BY ETL__CreatedDate)
FROM ods.Emma_Contacts_Outbound_Json_Payload --WHERE QueueID IS NULL

--SELECT groupid, COUNT(1) FROM #working GROUP BY GroupID ORDER BY 1


DECLARE @max INT = (SELECT MAX(groupid) FROM #working)
DECLARE @count INT = 1


WHILE @count <= @max
BEGIN

INSERT INTO #tempQueue (APIName,APIEntity,EndpointName,SourceID,MemberID, Json_Payload,httpAction,[Description], GroupID)

SELECT 'api' APIName, 'epient' APIEntity, 'members'EndpointName, a.accountID AS SourceID , a.MemberID AS MemberID
	, (
		SELECT a.SSB_CRMSYSTEM_CONTACT_ID AS [fields.ssbcrmsystemcontactid]
			--, a.Email AS fields.email
			, a.FirstName					AS [fields.first_name]
			, a.LastName					AS [fields.last_name]
			, a.Suffix						AS [fields.suffix]
			, a.Gender						AS [fields.gender]
			, a.Birthday					AS [fields.birthday]
			, a.[Address]					AS [fields.address]
			, a.Address2					AS [fields.address-2]
			, a.City						AS [fields.city]
			, a.[State]						AS [fields.state]
			, a.PostalCode					AS [fields.postal_code]
			, a.County						AS [fields.county]
			, a.Country						AS [fields.country]
			, a.SSBRecordSource				AS [fields.ssb-record-source]
			, a.SSBIsNewRecord				AS [fields.ssb-is-new-record]
			, a.SecondaryEmail				AS [fields.secondary-email]
			, a.Phone						AS [fields.phone]
			, a.CompanyName					AS [fields.company-name]
			, a.ArchticsID					AS [fields.acct-id]
			, a.AccountRepName				AS [fields.account-rep-name]
			, a.AccountRepEmail				AS [fields.account-rep-email]
			, a.AccountRepPhone				AS [fields.account-rep-phone]
			, a.SSBBulldog					AS [fields.ssb-bulldog]
			, a.SSBSeasonTicketHolder		AS [fields.ssb-season-ticket-holder]
			, a.SSBPartialPlanBuyer			AS [fields.ssb-partial-plan-buyer]
			, a.SSBClubTicketBuyer			AS [fields.ssb-club-ticket-buyer]
			, a.SSBSuiteTicketBuyer			AS [fields.ssb-suite-ticket-buyer]
			, a.SSBGroupTicketBuyer			AS [fields.ssb-group-ticket-buyer]
			, a.SSBSingleGameTicketBuyer	AS [fields.ssb-single-game-ticket-buyer]
			, a.SSBParkingBuyer				AS [fields.ssb-parking-buyer]
			, a.SSBMostRecentEvent			AS [fields.ssb-most-recent-event]
			, a.SSBNextEvent				AS [fields.ssb-next-event]
			, a.SSBSeatLocation				AS [fields.ssb-seat-location]
			, a.SSBSeatQty					AS [fields.ssb-seat-qty]
			, a.SSBTMSinceDate				AS [fields.ssb-tm-since-date]
		FOR JSON PATH) AS json_payload
		,'Put' httpAction
		,CASE WHEN a.SSBIsNewRecord = 1 THEN 'This is a new record'
			ELSE 'This is a write back to Emma' END AS [Description]
		,@count GroupID
 FROM   ods.Emma_Contacts_Outbound_Json_Payload a
  JOIN #working b ON a.[MemberID] = b.SSID
 WHERE b.GroupID = @count
 AND a.AccountID NOT IN (1745287, 1729928)
 AND ETL__CreatedDate >= (GETDATE()-3)

 
SET @count = @count + 1

END

INSERT INTO ods.API_OutboundQueue
	(APIName,
    APIEntity,
    EndpointName,
    SourceID,
	MemberID,
    Json_Payload,
    httpAction,
    [Description]
	)
SELECT 
	APIName,
    APIEntity,
    EndpointName,
    SourceID,
	MemberID,
    Json_Payload,
    httpAction,
    [Description]
FROM #tempQueue;

GO
