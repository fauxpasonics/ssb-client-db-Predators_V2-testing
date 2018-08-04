SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Kaitlyn Sniffin
-- Create date: 09/15/2017
-- Description:	Load FanMaker Visits Proc
-- =============================================
CREATE PROCEDURE [apietl].[Load_Fanmaker_Visits]
AS
BEGIN

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

	-- Load all adjustments to temp table
	SELECT GETDATE() AS ETL__CreatedDate
		, GETDATE() AS ETL__UpdatedDate
		, CAST(ud.email AS NVARCHAR(200)) email
		, udv.ETL__fanmaker_userinfo_data_visits_id visit_id
		, udv.last_login
		, udv.desktop
		, udv.mobile
	INTO #src
	--SELECT *
	FROM apietl.fanmaker_userinfo_data_visits_2 udv
	JOIN apietl.fanmaker_userinfo_data_1 ud
		ON ud.ETL__fanmaker_userinfo_data_id = udv.ETL__fanmaker_userinfo_data_id
	JOIN MaxSession m
		ON m.ETL__fanmaker_userinfo_id = ud.ETL__fanmaker_userinfo_id
	
	-- Add index to temp table
	CREATE NONCLUSTERED INDEX idx_tmp on #src (email, visit_id);


	-- Merge records with ods table
	MERGE ods.FanMaker_Visits AS TARGET
	USING #src AS SOURCE
		ON Target.email = SOURCE.email
		AND Target.visit_id = SOURCE.visit_id

		-- Only update the existing record if the adjustment date is earlier than the adjustment date in the ods table
		WHEN MATCHED AND SOURCE.last_login < TARGET.last_login
		THEN UPDATE SET
			  TARGET.ETL__CreatedDate = SOURCE.ETL__CreatedDate
			, TARGET.ETL__UpdatedDate = SOURCE.ETL__UpdatedDate
			, TARGET.email = SOURCE.email
			, TARGET.visit_id = SOURCE.visit_id
			, TARGET.last_login = SOURCE.last_login
			, TARGET.desktop = SOURCE.desktop
			, TARGET.mobile = SOURCE.mobile


		-- Insert new records
		WHEN NOT MATCHED THEN INSERT (
			  ETL__CreatedDate
			, ETL__UpdatedDate
			, email
			, visit_id
			, last_login
			, desktop
			, mobile
		)
		VALUES (
			SOURCE.ETL__CreatedDate
			, SOURCE.ETL__UpdatedDate
			, SOURCE.email
			, SOURCE.visit_id
			, SOURCE.last_login
			, SOURCE.desktop
			, SOURCE.mobile
			);

END

GO
