SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [segmentation].[vw__Fanmaker_Social]
AS

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, f.Email
	, f.Twitter
	, f.Foursquare
	, f.Facebook
	, f.Instagram
	, f.TVTag
	, f.Shopify
	, f.Pinterest
	, f.Tumblr
FROM ods.FanMaker_Social f
JOIN dbo.DimCustomer dc ON f.email = dc.SSID
JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.dimcustomerid


--SELECT TOP 10 * FROM ods.fanmaker_Social


GO
