SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [segmentation].[Load_Emma_Opens]
AS


TRUNCATE TABLE segmentation.Emma_Opens

DROP INDEX segmentation.Emma_Opens.[IDX_keys]

INSERT INTO segmentation.Emma_Opens
        ( SSB_CRMSYSTEM_CONTACT_ID ,
          Email ,
          Account ,
          Mailing ,
          Contact ,
          [Timestamp] ,
          [Subject] ,
          [Name]
        )

SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, e.Email
	, e.Account
	, e.Mailing
	, e.Contact
	, MIN(e.[Timestamp]) [Timestamp]
	, m.[Subject]
	, m.[Name]
FROM ods.Emma_Opens e
JOIN ods.emma_Mailings m ON e.Mailing = m.Mailing
JOIN dbo.dimcustomer dc ON e.Email = dc.EmailPrimary
JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.DimCustomerId
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, e.Email, e.Account, e.Mailing
	, e.Contact, [m].[Subject], [m].[Name]




CREATE NONCLUSTERED INDEX [IDX_keys] ON [segmentation].[Emma_Opens]
(
	[SSB_CRMSYSTEM_CONTACT_ID] ASC,
	[Account] ASC,
	[Mailing] ASC,
	[Contact] ASC
)
INCLUDE ( 	[Email]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]



GO
