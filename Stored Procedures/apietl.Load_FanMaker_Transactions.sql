SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Kaitlyn Sniffin
-- Create date: 04/05/2017
-- Description:	Load FanMaker Transactions Proc
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_Transactions]
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
        MERGE ods.FanMaker_Transactions AS TARGET
        USING
            (
              SELECT    GETDATE() AS ETL__CreatedDate
                      , GETDATE() AS ETL__UpdatedDate
                      , udt.transaction_id
                      , udt.transaction_number
                      , udt.event_id
                      , udt.location_id
                      , udt.terminal_id
                      , udt.member_id
                      , ud.email
                      , udtti.[name]
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
                        AS udtti ON udtti.ETL__fanmaker_userinfo_data_transactions_id = udt.ETL__fanmaker_userinfo_data_transactions_id
                        INNER JOIN apietl.fanmaker_userinfo_data_1 AS ud ON ud.ETL__fanmaker_userinfo_data_id = udt.ETL__fanmaker_userinfo_data_id
						JOIN MaxSession m ON m.ETL__fanmaker_userinfo_id = ud.ETL__fanmaker_userinfo_id
			) AS SOURCE
        ON ( TARGET.transaction_id = SOURCE.transaction_id
             AND TARGET.email = SOURCE.email
			 AND TARGET.[name] = SOURCE.[name]
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
                   , [name]
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
                   , SOURCE.[name]
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
