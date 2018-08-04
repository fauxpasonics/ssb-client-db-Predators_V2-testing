SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		Kaitlyn Sniffin
-- Create date: 04/05/2017
-- Description:	Load FanMaker Activities Proc
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_Activities]
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


SELECT GETDATE() AS ETL__CreatedDate
       , GETDATE() AS ETL__UpdatedDate
       , ud.email
       , uda.[identity]
       , uda.[type]
       , uda.subtype
       , uda.[subject]
       , CAST(uda.created_at AS DATETIME2) created_at
       , uda.source_url
       , CAST(uda.worth AS INT) worth
       , CAST(uda.awarded AS INT) awarded
into #src
FROM apietl.fanmaker_userinfo_data_activities_2 AS uda
JOIN apietl.fanmaker_userinfo_data_1 AS ud
	ON ud.ETL__fanmaker_userinfo_data_id = uda.ETL__fanmaker_userinfo_data_id
JOIN MaxSession m
	ON m.ETL__fanmaker_userinfo_id = ud.ETL__fanmaker_userinfo_id

;
--create nonclustered index idx_tmp on #src(email,[identity]);


MERGE ods.FanMaker_Activities AS TARGET
USING #src AS SOURCE
	ON TARGET.email = SOURCE.email
    AND TARGET.[identity] = SOURCE.[identity]

-- only update the existing record if created_at date is earlier 
WHEN MATCHED AND SOURCE.created_at < TARGET.created_at
THEN UPDATE
SET TARGET.ETL__CreatedDate = SOURCE.ETL__CreatedDate
	, TARGET.ETL__UpdatedDate = SOURCE.ETL__UpdatedDate
	, TARGET.email = SOURCE.email
	, TARGET.[identity] = SOURCE.[identity]
	, TARGET.[type] = SOURCE.[type]
	, TARGET.subtype = SOURCE.subtype
	, TARGET.[subject] = SOURCE.[subject]
	, TARGET.created_at = SOURCE.created_at
	, TARGET.source_url = SOURCE.source_url
	, TARGET.worth = SOURCE.worth
	, TARGET.awarded = SOURCE.awarded

WHEN NOT MATCHED THEN INSERT (
	ETL__CreatedDate
	, ETL__UpdatedDate
    , email
    , [identity]
    , [type]
    , subtype
    , [subject]
    , created_at
    , source_url
    , worth
    , awarded
)
VALUES (
	SOURCE.ETL__CreatedDate
    , SOURCE.ETL__UpdatedDate
    , SOURCE.email
    , SOURCE.[identity]
    , SOURCE.[type]
    , SOURCE.subtype
    , SOURCE.[subject]
    , SOURCE.created_at
    , SOURCE.source_url
    , SOURCE.worth
    , SOURCE.awarded
);


END




GO
