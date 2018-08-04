SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[Load_ods_Emma_Mailings]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN

	SELECT DISTINCT ETL__SourceFileName 
	INTO #stgFiles
	FROM stg.Emma_Mailings

	DELETE t
	FROM ods.Emma_Mailings t
	INNER JOIN #stgFiles s ON t.ETL__SourceFileName = s.ETL__SourceFileName


	INSERT INTO ods.Emma_Mailings
	( 
		ETL__CreatedDate, ETL__UpdatedDate, ETL__IsDeleted, ETL__DeltaHashKey, ETL__SourceFileName
		, Mailing, Account, Parent, Timestamp, MailingsCount, Mailing_Type, Subject, Name, Signup
	)

	SELECT GETDATE() ETL__CreatedDate, GETDATE() ETL__UpdatedDate, 0 ETL__IsDeleted, NULL ETL__DeltaHashKey, ETL__SourceFileName
	, Mailing, Account, Parent, Timestamp, MailingsCount, Mailing_Type, Subject, Name, Signup
	FROM stg.Emma_Mailings



END




GO
