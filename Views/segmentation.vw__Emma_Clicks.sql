SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [segmentation].[vw__Emma_Clicks]
AS

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, e.Email
	, e.Account
	, e.Mailing
	, e.Contact
	, e.Link
	, MIN(e.[Timestamp]) AS [Timestamp]
	, m.[Subject]
	, m.[Name]
	, COUNT(*) CountClicks
FROM ods.Emma_Clicks e
JOIN dbo.dimcustomer dc ON e.Email = dc.EmailPrimary
JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.DimCustomerId
JOIN ods.Emma_Mailings m ON e.Mailing = m.Mailing
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, e.Email, e.Account, e.Mailing
	, e.Contact, e.Link, [subject], [name]
HAVING MIN(m.[Timestamp]) >= DATEADD(mm,-6,GETDATE())










GO
