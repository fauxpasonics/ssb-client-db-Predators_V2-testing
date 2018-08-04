SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [segmentation].[vw__Emma_Opens]
AS

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID ,
       o.Email ,
       o.Account ,
       o.Mailing ,
       o.Contact ,
       o.[Timestamp] ,
       m.[Subject] ,
       m.[Name]
FROM ods.Emma_Opens o (NOLOCK)
JOIN ods.Emma_Mailings m (NOLOCK)
    ON o.Mailing = m.Mailing
JOIN dbo.dimcustomer dc (NOLOCK)
    ON o.Email = dc.EmailPrimary
    AND dc.SourceSystem = 'Emma'
JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
    ON dc.DimCustomerId = ssbid.DimCustomerSSBID
WHERE m.[Timestamp] >= DATEADD(mm,-6,GETDATE())






GO
