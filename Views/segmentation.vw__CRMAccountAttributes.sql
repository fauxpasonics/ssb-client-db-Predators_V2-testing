SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [segmentation].[vw__CRMAccountAttributes]
AS

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID, pc.donotbulkemail, pc.donotbulkpostalmail, pc.donotemail, pc.donotfax, pc.donotphone, pc.donotpostalmail, pc.donotsendmm
	, pc.owneridname, pc.createdbyname, pc.modifiedbyname, pc.opendeals_date, pc.openrevenue_date str_source, pc.str_partnersalespersonname
FROM Predators_Reporting.prodcopy.Account pc
JOIN dbo.dimcustomer dc ON CAST(pc.accountid AS NVARCHAR(100)) = dc.SSID
JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.DimCustomerId






GO
