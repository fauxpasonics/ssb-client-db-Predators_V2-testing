SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ismail Fuseini
-- Create date: 11/29/2016
-- Description:	Load FanMaker Transactions sProc
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_Transactions_Old]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE ods.FanMaker_Transactions AS TARGET
        USING
            (
              SELECT    CAST(ud.created_at AS DATETIME2) AS ETL__CreatedDate
                      , GETDATE() AS ETL__UpdatedDate
                      , udt.transaction_id
                      , udt.transaction_number
                      , udt.event_id
                      , udt.location_id
                      , udt.terminal_id
                      , udt.member_id
                      , ud.email
                      , udtti.name
                      , udtti.category
                      , udtti.bucket
                      , CAST(udt.purchased_at AS DATETIME2) AS purchased_at
                      , CAST(udt.created_at AS DATETIME2) AS created_at
                      , udt.data_type
                      , udt.table_number
                      , CAST(udtti.total_cents AS INT) AS total_cents
                      , CAST(udtti.price_cents AS INT) AS price_cents
                      , CAST(udtti.quantity AS INT) AS quantity
              FROM      apietl.fanmaker_userinfo_data_transactions_2 AS udt
                        INNER JOIN apietl.fanmaker_userinfo_data_transactions_transaction_items_3
                        AS udtti ON udtti.fanmaker_userinfo_data_transactions_id = udt.fanmaker_userinfo_data_transactions_id
                        INNER JOIN apietl.fanmaker_userinfo_data_1 AS ud ON ud.fanmaker_userinfo_data_id = udt.fanmaker_userinfo_data_id
            ) AS SOURCE
        ON ( TARGET.ETL__CreatedDate = SOURCE.ETL__CreatedDate
             AND TARGET.transaction_id = SOURCE.transaction_id
             AND TARGET.email = SOURCE.email
           )
        WHEN NOT MATCHED THEN
            INSERT ( ETL__CreatedDate
                   , ETL__UpdatedDate
                   , transaction_id
                   , transaction_number
                   , event_id
                   , location_id
                   , terminal_id
                   , member_id
                   , email
                   , name
                   , category
                   , bucket
                   , purchased_at
                   , created_at
                   , data_type
                   , table_number
                   , total_cents
                   , price_cents
                   , quantity
	
	               )
            VALUES ( SOURCE.ETL__CreatedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.transaction_id
                   , SOURCE.transaction_number
                   , SOURCE.event_id
                   , SOURCE.location_id
                   , SOURCE.terminal_id
                   , SOURCE.member_id
                   , SOURCE.email
                   , SOURCE.name
                   , SOURCE.category
                   , SOURCE.bucket
                   , SOURCE.purchased_at
                   , SOURCE.created_at
                   , SOURCE.data_type
                   , SOURCE.table_number
                   , SOURCE.total_cents
                   , SOURCE.price_cents
                   , SOURCE.quantity
                   );
    END;


GO
