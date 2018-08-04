SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_Contacts_DoNotUpdate]
AS

WITH SSBID AS (
	
				SELECT DISTINCT c.new_ssbcrmsystemcontactid
				FROM Predators_Reporting.prodcopy.account a (NOLOCK)
				JOIN Predators_Reporting.prodcopy.contact c (NOLOCK) ON a.accountid = c.parentcustomerid
				WHERE a.new_ssbdonotedit = 1

				)


SELECT DISTINCT dc.DimCustomerID, ssbid.SSB_CRMSYSTEM_CONTACT_ID SSBID, dc.SSID
FROM SSBID vw
JOIN dbo.dimcustomerssbid ssbid (NOLOCK) ON vw.new_ssbcrmsystemcontactid = ssbid.SSB_CRMSYSTEM_CONTACT_ID
JOIN dbo.dimcustomer dc (NOLOCK) ON ssbid.DimCustomerid = dc.DimCustomerId
WHERE dc.SourceSystem = 'CRM_Contacts'


GO
