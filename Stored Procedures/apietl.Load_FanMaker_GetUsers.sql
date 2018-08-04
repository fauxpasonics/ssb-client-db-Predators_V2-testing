SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ismail Fuseini
-- Create date: 1/25/2017
-- Description:	
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_GetUsers]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE stg.FanMaker_GetUsers AS TARGET
        USING
            (
              SELECT    vfmgu.username
                      , vfmgu.created_at
                      , vfmgu.pbr_id
                      , vfmgu.qrcode
                      , vfmgu.rfid
                      , vfmgu.pid
                      , vfmgu.outbox_id
                      , vfmgu.gpsid
					  , vfmgu.ticketmasterID
              FROM      apietl.vw_FanMaker_GetUsers AS vfmgu
            ) AS SOURCE
        ON TARGET.username = SOURCE.username
		WHEN MATCHED --AND SOURCE.created_at > TARGET.created_at
		THEN
			UPDATE SET
				TARGET.created_at = SOURCE.created_at
				, TARGET.pbr_id = SOURCE.pbr_id
				, TARGET.qrcode = SOURCE.qrcode
				, TARGET.rfid = SOURCE.rfid
				, TARGET.pid = SOURCE.pid
				, TARGET.outbox_id = SOURCE.outbox_id
				, TARGET.gpsid = SOURCE.gpsid
				, TARGET.ticketmasterID = SOURCE.ticketmasterID

        WHEN NOT MATCHED THEN
            INSERT ( username
                   , created_at
                   , pbr_id
                   , qrcode
                   , rfid
                   , pid
                   , outbox_id
                   , gpsid
				   , ticketmasterID
	               )
            VALUES ( SOURCE.username
                   , SOURCE.created_at
                   , SOURCE.pbr_id
                   , SOURCE.qrcode
                   , SOURCE.rfid
                   , SOURCE.pid
                   , SOURCE.outbox_id
                   , SOURCE.gpsid
				   , SOURCE.ticketmasterID
	
	               );

	
    END;

GO
