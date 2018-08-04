SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [segmentation].[vw__CRMContactAttributes]
AS

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID, pc.donotbulkemail, pc.donotbulkpostalmail, pc.donotemail, pc.donotfax, pc.donotphone, pc.donotpostalmail, pc.donotsendmm
	, pc.owneridname, pc.str_clientproximity, pc.str_lastactivitydate, pc.str_openactivitycount, pc.str_openticketopportunity, pc.str_oppdaysinstage
	, pc.str_oppproduct, pc.str_oppsource, pc.str_oppstage, str_source
FROM Predators_Reporting.prodcopy.Contact pc
JOIN dbo.dimcustomer dc ON CAST(pc.contactid AS NVARCHAR(100)) = dc.SSID
JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.DimCustomerId








GO
