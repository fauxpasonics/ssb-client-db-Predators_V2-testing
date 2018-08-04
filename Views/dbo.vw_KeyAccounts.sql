SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dbo].[vw_KeyAccounts]
AS 

WITH SSBID AS (
	SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	FROM mdm.vw_TM_STH vw
	JOIN dbo.dimcustomerssbid ssbid ON vw.dimcustomerid = ssbid.DimCustomerid
	WHERE vw.Suite = 1 --OR  vw.STH = 1 --JT/Mike decided to remove STHs from this view in order to allow us to merge STHs.
	
	UNION

	SELECT DISTINCT SSBID
	FROM dbo.vw_Contacts_DoNotUpdate
	)


SELECT ssbid.DimCustomerID, ssbid.SSB_CRMSYSTEM_CONTACT_ID SSBID, ssbid.SSID
FROM SSBID vw
JOIN dbo.vwDimCustomer_ModAcctId ssbid ON ssbid.SSB_CRMSYSTEM_CONTACT_ID = vw.SSB_CRMSYSTEM_CONTACT_ID
WHERE ssbid.SourceSystem = 'CRM_Contacts'



GO
