SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ismail Fuseini
-- Create date: 11/29/2016
-- Description:	Load FanMaker Devices sProc
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_Devices_Old]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE ods.FanMaker_Devices AS TARGET
        USING
            (
              SELECT    GETDATE() AS ETL__UpdatedDate
                      , ud.email
                      , udd.device_type
                      , udd.os
                      , udd.app_name
              FROM      apietl.fanmaker_userinfo_data_devices_2 AS udd
                        INNER JOIN apietl.fanmaker_userinfo_data_1 AS ud ON ud.fanmaker_userinfo_data_id = udd.fanmaker_userinfo_data_id
            ) AS SOURCE
        ON ( TARGET.email = SOURCE.email
             AND TARGET.device_type = SOURCE.device_type
             AND TARGET.os = SOURCE.os
             AND TARGET.app_name = SOURCE.app_name
           )
        WHEN NOT MATCHED THEN
            INSERT ( ETL__UpdatedDate
                   , email
                   , device_type
                   , os
                   , app_name
                   )
            VALUES ( SOURCE.ETL__UpdatedDate
                   , SOURCE.email
                   , SOURCE.device_type
                   , SOURCE.os
                   , SOURCE.app_name
	
	               );
    END;


GO
