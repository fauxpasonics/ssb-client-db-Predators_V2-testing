SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Kaitlyn Sniffin
-- Create date: 09/12/2017
-- Description:	Load FanMaker Adjustments Proc
-- =============================================
CREATE PROCEDURE [apietl].[Load_Fanmaker_Adjustments]
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
		, uda.ETL__fanmaker_userinfo_data_adjustments_id AS adjustment_id
		, uda.[date] AS adjustment_date
		, uda.reason AS adjustment_reason
		, uda.points AS adjustment_points
	INTO #src
	FROM apietl.fanmaker_userinfo_data_adjustments_2 uda
	JOIN apietl.fanmaker_userinfo_data_1 ud
		ON ud.ETL__fanmaker_userinfo_data_id = uda.ETL__fanmaker_userinfo_data_id
	JOIN MaxSession m
		ON m.ETL__fanmaker_userinfo_id = ud.ETL__fanmaker_userinfo_id
	
	-- Add index to temp table
	CREATE NONCLUSTERED INDEX idx_tmp on #src (email, adjustment_id);


	-- Merge records with ods table
	MERGE ods.FanMaker_Adjustments AS TARGET
	USING #src AS SOURCE
		ON Target.email = SOURCE.email
		AND Target.adjustment_id = SOURCE.adjustment_id

		-- Only update the existing record if the adjustment date is earlier than the adjustment date in the ods table
		WHEN MATCHED AND SOURCE.adjustment_date < TARGET.adjustment_date
		THEN UPDATE SET
			  TARGET.ETL__CreatedDate = SOURCE.ETL__CreatedDate
			, TARGET.ETL__UpdatedDate = SOURCE.ETL__UpdatedDate
			, TARGET.email = SOURCE.email
			, TARGET.adjustment_id = SOURCE.adjustment_id
			, TARGET.adjustment_date = SOURCE.adjustment_date
			, TARGET.adjustment_reason = SOURCE.adjustment_reason
			, TARGET.adjustment_points = SOURCE.adjustment_points


		-- Insert new records
		WHEN NOT MATCHED THEN INSERT (
			  ETL__CreatedDate
			, ETL__UpdatedDate
			, email
			, adjustment_id
			, adjustment_date
			, adjustment_reason
			, adjustment_points
		)
		VALUES (
			SOURCE.ETL__CreatedDate
			, SOURCE.ETL__UpdatedDate
			, SOURCE.email
			, SOURCE.adjustment_id
			, SOURCE.adjustment_date
			, SOURCE.adjustment_reason
			, SOURCE.adjustment_points
			);

END

GO
