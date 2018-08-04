SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [apietl].[vw_FanMaker_GetUsers]
AS
    WITH    identifier_pivot
              AS (
                   SELECT   fgdi.ETL__fanmaker_getusers_data_id
                          , MIN(CASE WHEN type = 'pbr_id' THEN identifier
                                     ELSE NULL
                                END) pbr_id
                          , MIN(CASE WHEN type = 'qrcode' THEN identifier
                                     ELSE NULL
                                END) qrcode
                          , MIN(CASE WHEN type = 'rfid' THEN identifier
                                     ELSE NULL
                                END) rfid
                          , MIN(CASE WHEN type = 'pid' THEN identifier
                                     ELSE NULL
                                END) pid
                          , MIN(CASE WHEN type = 'outbox_id' THEN identifier
                                     ELSE NULL
                                END) outbox_id
                          , MIN(CASE WHEN type = 'gpsid' THEN identifier
                                     ELSE NULL
                                END) gpsid
						  , MIN(CASE WHEN fgdi.type = 'ticketmasterID' THEN fgdi.identifier
									 ELSE NULL
								END) ticketmasterID
                   FROM     apietl.fanmaker_getusers_data_identifiers_2 AS fgdi
                   GROUP BY fgdi.ETL__fanmaker_getusers_data_id
                 )
    SELECT  fgd.username
          , fgd.created_at
          , identifier_pivot.pbr_id
          , identifier_pivot.qrcode
          , identifier_pivot.rfid
          , identifier_pivot.pid
          , identifier_pivot.outbox_id
          , identifier_pivot.gpsid
		  , identifier_pivot.ticketmasterID
    FROM    apietl.fanmaker_getusers_0 AS fg
            JOIN apietl.fanmaker_getusers_data_1 AS fgd ON fgd.ETL__fanmaker_getusers_id = fg.ETL__fanmaker_getusers_id
            LEFT OUTER JOIN identifier_pivot ON identifier_pivot.ETL__fanmaker_getusers_data_id = fgd.ETL__fanmaker_getusers_data_id;


GO
