SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Emma_Load_PostProcessing]

AS
BEGIN


SELECT DISTINCT ETL__SourceFileName
, master.dbo.fnGetValueFromDelimitedString(ETL__SourceFileName, '-', 1) Calc_AccountId
INTO #Clicks_Calc_AccountId
FROM ods.Emma_Clicks
WHERE Calc_AccountId IS NULL

UPDATE o
SET o.Calc_AccountId = a.Calc_AccountId
FROM ods.Emma_Clicks o
INNER JOIN #Clicks_Calc_AccountId a ON o.ETL__SourceFileName = a.ETL__SourceFileName



SELECT DISTINCT ETL__SourceFileName, CAST(NULL AS INT) Calc_AccountId
INTO #Deliveries_Calc_AccountId
FROM ods.Emma_Deliveries
WHERE Calc_AccountId IS NULL

UPDATE #Deliveries_Calc_AccountId
SET Calc_AccountId = master.dbo.fnGetValueFromDelimitedString(ETL__SourceFileName, '-', 1)
WHERE Calc_AccountId IS NULL

UPDATE o
SET o.Calc_AccountId = a.Calc_AccountId
FROM ods.Emma_Deliveries o
INNER JOIN #Deliveries_Calc_AccountId a ON o.ETL__SourceFileName = a.ETL__SourceFileName



SELECT DISTINCT ETL__SourceFileName
, master.dbo.fnGetValueFromDelimitedString(ETL__SourceFileName, '-', 1) Calc_AccountId
INTO #Mailings_Calc_AccountId
FROM ods.Emma_Mailings
WHERE Calc_AccountId IS NULL

UPDATE o
SET o.Calc_AccountId = a.Calc_AccountId
FROM ods.Emma_Mailings o
INNER JOIN #Mailings_Calc_AccountId a ON o.ETL__SourceFileName = a.ETL__SourceFileName



SELECT DISTINCT ETL__SourceFileName, CAST(NULL AS INT) Calc_AccountId
INTO #Opens_Calc_AccountId
FROM ods.Emma_Opens
WHERE Calc_AccountId IS NULL

UPDATE #Opens_Calc_AccountId
SET Calc_AccountId = master.dbo.fnGetValueFromDelimitedString(ETL__SourceFileName, '-', 1)
WHERE Calc_AccountId IS NULL

UPDATE o
SET o.Calc_AccountId = a.Calc_AccountId
, o.ETL__UpdatedDate = GETDATE()
FROM ods.Emma_Opens o
INNER JOIN #Opens_Calc_AccountId a ON o.ETL__SourceFileName = a.ETL__SourceFileName



SELECT DISTINCT ETL__SourceFileName
, master.dbo.fnGetValueFromDelimitedString(ETL__SourceFileName, '-', 1) Calc_AccountId
INTO #OptOuts_Calc_AccountId
FROM ods.Emma_Optouts
WHERE Calc_AccountId IS NULL

UPDATE o
SET o.Calc_AccountId = a.Calc_AccountId
FROM ods.Emma_Optouts o
INNER JOIN #OptOuts_Calc_AccountId a ON o.ETL__SourceFileName = a.ETL__SourceFileName


SELECT DISTINCT ETL__SourceFileName
, master.dbo.fnGetValueFromDelimitedString(ETL__SourceFileName, '-', 1) Calc_AccountId
INTO #Shares_Calc_AccountId
FROM ods.Emma_Shares
WHERE Calc_AccountId IS NULL

UPDATE o
SET o.Calc_AccountId = a.Calc_AccountId
FROM ods.Emma_Shares o
INNER JOIN #Shares_Calc_AccountId a ON o.ETL__SourceFileName = a.ETL__SourceFileName




END






GO
