SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [segmentation].[vw__Fanmaker_Activities]
AS

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, f.Email
	, f.[Identity] ActivityIdentity
	, f.[Type]
	, f.Subtype
	, f.[Subject]
	, f.Created_at CreatedAt
	, f.Source_url SourceURL
	, f.Worth
	, f.Awarded
FROM ods.FanMaker_Activities f
JOIN dbo.DimCustomer dc ON f.email = dc.SSID
JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.dimcustomerid
WHERE f.created_at >= (GETDATE() - 365)






GO
