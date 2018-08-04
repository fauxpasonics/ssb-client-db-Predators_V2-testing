SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[DimClassTM_KeyLookup] AS (

SELECT a.DimClassTMId, a.ETL_SourceSystem, a.ETL_SSID_class_id, a.ClassName
FROM (
	SELECT DimClassTMId, ETL_SourceSystem, ETL_SSID_class_id, ClassName
	, ROW_NUMBER() OVER(PARTITION BY ClassName ORDER BY ETL_UpdatedDate) RowRank
	FROM dbo.DimClassTM
) a 
WHERE a.RowRank = 1

)
GO
