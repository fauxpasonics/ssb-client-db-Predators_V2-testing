SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [segmentation].[vw__Emma_Optouts]
AS
SELECT DISTINCT 
ssbid.SSB_CRMSYSTEM_CONTACT_ID, e.Email, e.Account, e.Mailing, e.Contact, e.[Timestamp], m.[Subject], m.[Name]
FROM ods.Emma_Optouts e
JOIN dbo.dimcustomer dc ON e.Email = dc.EmailPrimary
JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.DimCustomerId
JOIN ods.emma_Mailings m ON e.Mailing = m.Mailing
WHERE m.[Timestamp] >= DATEADD(mm,-6,GETDATE())







GO
