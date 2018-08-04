SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Kaitlyn Sniffin
-- Create date: 04/05/2017
-- Description:	Load FanMaker Devices sProc
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_Devices]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

		WITH MaxSession
		AS (
			SELECT a.ETL__multi_query_value_for_audit email, a.ETL__fanmaker_userinfo_id
			FROM apietl.fanmaker_userinfo_0 a
			JOIN (
				SELECT ETL__multi_query_value_for_audit, MAX(ETL__session_id) SessionID
				FROM apietl.fanmaker_userinfo_0
				GROUP BY ETL__multi_query_value_for_audit
				) b ON a.ETL__multi_query_value_for_audit = b.ETL__multi_query_value_for_audit
					AND a.ETL__session_id = b.SessionID
			)

    -- Insert statements for procedure here
        MERGE ods.FanMaker_Devices AS TARGET
        USING
            (
              SELECT    GETDATE() AS ETL__UpdatedDate
                      , ud.email
                      , udd.device_type
                      , udd.os
                      , udd.[app_name]
              FROM      apietl.fanmaker_userinfo_data_devices_2 AS udd
              INNER JOIN apietl.fanmaker_userinfo_data_1 AS ud
					ON ud.ETL__fanmaker_userinfo_data_id = udd.ETL__fanmaker_userinfo_data_id
			  JOIN MaxSession m
					ON m.ETL__fanmaker_userinfo_id = ud.ETL__fanmaker_userinfo_id
            ) AS SOURCE
        ON ( TARGET.email = SOURCE.email
             AND TARGET.device_type = SOURCE.device_type
             AND TARGET.os = SOURCE.os
             AND TARGET.[app_name] = SOURCE.[app_name]
           )
        WHEN NOT MATCHED THEN
            INSERT ( ETL__UpdatedDate
                   , email
                   , device_type
                   , os
                   , [app_name]
                   )
            VALUES ( SOURCE.ETL__UpdatedDate
                   , SOURCE.email
                   , SOURCE.device_type
                   , SOURCE.os
                   , SOURCE.[app_name]
	
	               );
    END;

GO
