SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [segmentation].[vw__Fanmaker_Devices]
AS

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, f.Email
	, f.device_type DeviceType
	, f.OS
	, f.[app_name] AppName
FROM ods.FanMaker_Devices f
JOIN dbo.DimCustomer dc ON f.email = dc.SSID
JOIN dbo.dimcustomerssbid ssbid ON dc.DimCustomerId = ssbid.dimcustomerid


--SELECT TOP 10 * FROM ods.fanmaker_Devices


GO
