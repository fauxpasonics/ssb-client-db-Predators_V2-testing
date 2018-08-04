SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[Load_Emma_EmailSummary_MSCRM]
AS

/*========================================================================================================
	Create distinct list of SSB_CRMSYSTEM_CONTACT_IDs and Email Addresses
========================================================================================================*/
SELECT DISTINCT dc.SSB_CRMSYSTEM_CONTACT_ID, dc.EmailPrimary
INTO #EmailMatches
FROM dbo.vwDimCustomer_ModAcctId dc
WHERE dc.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL
	AND dc.EmailPrimary IS NOT NULL
	AND dc.EmailPrimary <> ''
	AND dc.EmailPrimaryIsCleanStatus = 'Valid'

CREATE NONCLUSTERED INDEX idx_EmailMatches ON #EmailMatches(EmailPrimary);

/*========================================================================================================
	Map SSBID to mailing summary on email address
========================================================================================================*/
/*		edited by DCH on 2017-09-01

SELECT match.SSB_CRMSYSTEM_CONTACT_ID
	, em.MemberID
	, em.Email
	, emd.MailingID
	, emd.[Name] MailingName
	, emd.PublicWebviewURL
	, ed.Result DeliveryResult
	, COUNT(ed.ETL__ID) DeliveryCount
	, MIN(ed.[Timestamp]) MinDeliveryTime
	, COUNT(eo.ETL__ID) OpenCount
	, MIN(eo.[Timestamp]) MinOpenTime
	, COUNT(ec.ETL__ID) ClickCount
	, MIN(ec.[Timestamp]) MinClickTime
INTO #MappedGUIDs
FROM  ods.Emma_Members em (NOLOCK)
JOIN ods.Emma_MailingDetails_Members emm (NOLOCK)
	ON em.MemberID = emm.MemberID
JOIN ods.Emma_MailingDetails emd (NOLOCK)
	ON emd.MailingID = emm.MailingID
LEFT JOIN ods.Emma_Deliveries ed (NOLOCK)
	ON ed.Mailing = emm.MailingID
LEFT JOIN ods.Emma_Opens eo (NOLOCK)
	ON eo.mailing = emm.MailingID
LEFT JOIN ods.Emma_Clicks ec (NOLOCK)
	ON ec.Mailing = emm.MailingID
LEFT JOIN #EmailMatches match
	ON match.EmailPrimary = em.Email
GROUP BY match.SSB_CRMSYSTEM_CONTACT_ID, em.MemberID, em.Email, emd.MailingID, emd.[Name], emd.PublicWebviewURL, ed.Result

*/

--	first step
SELECT match.SSB_CRMSYSTEM_CONTACT_ID
	, em.MemberID
	, em.Email
	, emd.MailingID
	, emd.[Name] MailingName
	, emd.PublicWebviewURL
	, ed.Result DeliveryResult
	, COUNT(ed.ETL__ID) DeliveryCount
	, MIN(ed.[Timestamp]) MinDeliveryTime
	, MAX(ed.[Timestamp]) MaxDeliveryTime
INTO #MappedGUIDs_1
FROM  ods.Emma_Members em (NOLOCK)
JOIN ods.Emma_MailingDetails_Members emm (NOLOCK)
	ON em.MemberID = emm.MemberID
JOIN ods.Emma_MailingDetails emd (NOLOCK)
	ON emd.MailingID = emm.MailingID
LEFT JOIN ods.Emma_Deliveries ed (NOLOCK)
	ON ed.Mailing = emm.MailingID AND ed.Email = em.Email
LEFT JOIN #EmailMatches match
	ON match.EmailPrimary = em.Email
GROUP BY match.SSB_CRMSYSTEM_CONTACT_ID, em.MemberID, em.Email, emd.MailingID, emd.[Name], emd.PublicWebviewURL, ed.Result;


--	add opens
SELECT em.SSB_CRMSYSTEM_CONTACT_ID
	, em.MemberID
	, em.Email
	, em.MailingID
	, em.MailingName
	, em.PublicWebviewURL
	, em.DeliveryResult
	, em.DeliveryCount
	, em.MinDeliveryTime
	, em.MaxDeliveryTime
	, COUNT(eo.ETL__ID) OpenCount
	, MIN(eo.[Timestamp]) MinOpenTime
INTO #MappedGUIDs_2
FROM #MappedGUIDs_1 em
LEFT JOIN ods.Emma_Opens eo (NOLOCK)
	ON eo.mailing = em.MailingID AND eo.Email = em.Email
GROUP BY em.SSB_CRMSYSTEM_CONTACT_ID, em.MemberID, em.Email, em.MailingID, em.MailingName, em.PublicWebviewURL
	, em.DeliveryResult, em.DeliveryCount, em.MinDeliveryTime, em.MaxDeliveryTime;


--	add clicks
SELECT em.SSB_CRMSYSTEM_CONTACT_ID
	, em.MemberID
	, em.Email
	, em.MailingID
	, em.MailingName
	, em.PublicWebviewURL
	, em.DeliveryResult
	, em.DeliveryCount
	, em.MinDeliveryTime
	, em.MaxDeliveryTime
	, em.OpenCount
	, em.MinOpenTime
	, COUNT(ec.ETL__ID) ClickCount
	, MIN(ec.[Timestamp]) MinClickTime
INTO #MappedGUIDs
FROM #MappedGUIDs_2 em
LEFT JOIN ods.Emma_Clicks ec (NOLOCK)
	ON ec.Mailing = em.MailingID AND ec.Email = em.Email
GROUP BY em.SSB_CRMSYSTEM_CONTACT_ID, em.MemberID, em.Email, em.MailingID, em.MailingName, em.PublicWebviewURL
	, em.DeliveryResult, em.DeliveryCount, em.MinDeliveryTime, em.MaxDeliveryTime, em.OpenCount, em.MinOpenTime;


CREATE NONCLUSTERED INDEX idx_MappedGUIDs ON #MappedGUIDs(SSB_CRMSYSTEM_CONTACT_ID,MemberID,Email,MailingID,MailingName);

/*========================================================================================================
	Merge into 
========================================================================================================*/

BEGIN

	MERGE etl.Emma_EmailSummary_MSCRM AS TARGET
	USING #MappedGUIDs AS SOURCE
	ON (TARGET.SSB_CRMSYSTEM_CONTACT_ID = SOURCE.SSB_CRMSYSTEM_CONTACT_ID
		AND TARGET.MemberID = SOURCE.MemberID
		AND TARGET.EmailAddress = SOURCE.Email
		AND TARGET.MailingID = SOURCE.MailingID
		AND TARGET.MailingName = SOURCE.MailingName
		)
	WHEN MATCHED AND (TARGET.PublicWebviewURL <> SOURCE.PublicWebviewURL OR TARGET.DeliveryResult <> SOURCE.DeliveryResult
						OR TARGET.DeliveryCount <> SOURCE.DeliveryCount OR TARGET.MinDeliveryTime <> SOURCE.MinDeliveryTime OR TARGET.MaxDeliveryTime <> SOURCE.MaxDeliveryTime
						OR TARGET.OpenCount <> SOURCE.OpenCount	OR TARGET.MinOpenTime <> SOURCE.MinOpenTime
						OR TARGET.ClickCount <> SOURCE.ClickCount OR TARGET.MinClickTime <> SOURCE.MinClickTime
						)
	THEN
		UPDATE SET
			  TARGET.MailingName = SOURCE.MailingName
			, TARGET.PublicWebviewURL = SOURCE.PublicWebviewURL
			, TARGET.DeliveryResult = SOURCE.DeliveryResult
			, TARGET.DeliveryCount = SOURCE.DeliveryCount
			, TARGET.MinDeliveryTime = SOURCE.MinDeliveryTime
			, TARGET.MaxDeliveryTime = SOURCE.MaxDeliveryTime
			, TARGET.OpenCount = SOURCE.OpenCount
			, TARGET.MinOpenTime = SOURCE.MinOpenTime
			, TARGET.ClickCount = SOURCE.ClickCount
			, TARGET.MinClickTime = SOURCE.MinClickTime
			, TARGET.ETL_UpdatedDate = GETDATE()
	
	WHEN NOT MATCHED THEN
	INSERT (SSB_CRMSYSTEM_CONTACT_ID, MemberID, EmailAddress, MailingID, MailingName, PublicWebviewURL
			, DeliveryResult, DeliveryCount, MinDeliveryTime, MaxDeliveryTime, OpenCount, MinOpenTime, ClickCount
			, MinClickTime, ETL_CreatedDate, ETL_UpdatedDate)
	
	VALUES (
		SOURCE.SSB_CRMSYSTEM_CONTACT_ID
		, SOURCE.MemberID
		, SOURCE.Email
		, SOURCE.MailingID
		, SOURCE.MailingName
		, SOURCE.PublicWebviewURL
		, SOURCE.DeliveryResult
		, SOURCE.DeliveryCount
		, SOURCE.MinDeliveryTime
		, SOURCE.MaxDeliveryTime
		, SOURCE.OpenCount
		, SOURCE.MinOpenTime
		, SOURCE.ClickCount
		, SOURCE.MinClickTime
		, GETDATE()
		, GETDATE()
		);

END





GO
