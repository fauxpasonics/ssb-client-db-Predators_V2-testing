SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [segmentation].[Load_Emma_Deliveries]
AS


TRUNCATE TABLE segmentation.Emma_Deliveries

DROP INDEX segmentation.Emma_Deliveries.[IDX_keys]

INSERT INTO segmentation.Emma_Deliveries
        ( SSB_CRMSYSTEM_CONTACT_ID ,
          Email ,
          Account ,
          Mailing ,
          Contact ,
          [Timestamp] ,
          Result ,
          [Subject] ,
          [Name]
        )

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, e.Email
	, e.Account
	, e.Mailing
	, e.Contact
	, MIN(e.[Timestamp]) [Timestamp]
	, e.Result
	, m.[Subject]
	, m.[Name]
FROM ods.Emma_Deliveries e (NOLOCK)
JOIN ods.emma_Mailings m (NOLOCK) ON e.Mailing = m.Mailing
JOIN dbo.dimcustomer dc (NOLOCK) ON e.Email = dc.EmailPrimary
JOIN dbo.dimcustomerssbid ssbid (NOLOCK) ON dc.DimCustomerId = ssbid.DimCustomerId
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, e.Email, e.Account, e.Mailing, e.Contact, e.Result, [m].[Subject], [m].[Name]
--38 minutes, 7,596,201




CREATE NONCLUSTERED INDEX [IDX_keys] ON [segmentation].[Emma_Deliveries]
(
	[SSB_CRMSYSTEM_CONTACT_ID] ASC,
	[Account] ASC,
	[Mailing] ASC,
	[Contact] ASC
)
INCLUDE ( 	[Email]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
