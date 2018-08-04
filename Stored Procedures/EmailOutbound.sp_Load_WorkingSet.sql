SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*============================================================================================================
CREATED BY:		Kaitlyn Sniffin
CREATED DATE:	8/14/2017
PY VERSION:		N/A
USED BY:		Emma Outbound Integration
UPDATES:		8/10 jbarberio - added in logging
DESCRIPTION:	This PROC Identifies the Emails that will be pulled into the outbound process. Distinguishing 
				between current records to potentially be updated and new records to create.
NOTES:			Adapted from Jeff Barberio's sprocs for the Steelers outbound email integration
=============================================================================================================*/

CREATE PROCEDURE [EmailOutbound].[sp_Load_WorkingSet]
AS 



DECLARE @RunDate DATE = GETDATE()
DECLARE @RunTime DATETIME = GETDATE()
DECLARE @ProcName VARCHAR(200) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
DECLARE @LoadCount INT
DECLARE @ErrorMessage NVARCHAR(4000) 
DECLARE @ErrorSeverity INT			 
DECLARE @ErrorState INT				 

/*========================================================================================================================
													START TRY
========================================================================================================================*/

BEGIN TRY

		/*==========================================================================================
											IDENTIFY NEW INSERTS
		==========================================================================================*/

		--Identify Prod emails to exclude from new loads
		SELECT DISTINCT Email
		INTO #prod
		FROM ods.Emma_Members (NOLOCK)

		CREATE INDEX IX_email ON #prod (Email)

		CREATE TABLE #Inserts (
		EmailPrimary NVARCHAR(256)
		,RecordSource VARCHAR(50)
		,CreatedDate DATE
		)

		--============================
		--TM
		--============================

		INSERT INTO #Inserts (EmailPrimary,RecordSource,CreatedDate)

		SELECT dc.EmailPrimary,'TM', MIN(dd.CalDate) CreatedDate
		FROM dbo.FactTicketSales fts (NOLOCK)
			JOIN dbo.DimCustomer dc (NOLOCK) ON dc.DimCustomerId = fts.DimCustomerId
			JOIN dbo.DimDate dd (NOLOCK) ON dd.DimDateId = fts.DimDateId
			LEFT JOIN #prod prod ON prod.Email = dc.EmailPrimary
		WHERE prod.Email IS NULL
			  AND dc.SourceSystem = 'TM'
			  AND dc.EmailPrimaryIsCleanStatus LIKE 'Valid%'
		GROUP BY dc.EmailPrimary
		
		--============================
		--CRM Contacts
		--============================

		INSERT INTO #Inserts (EmailPrimary,RecordSource,CreatedDate)

		SELECT pc.emailaddress1, 'CRM_Contacts' , MIN(pc.CopyLoadDate) CreatedDate
		FROM Predators_Reporting.prodcopy.Contact pc (NOLOCK)
			JOIN dbo.DimCustomer dc (NOLOCK) ON dc.SSID = pc.contactid
			LEFT JOIN #prod prod ON prod.email = dc.EmailPrimary
		WHERE prod.Email IS NULL
			  AND dc.SourceSystem = 'CRM_Contacts'
			  AND dc.EmailPrimaryIsCleanStatus LIKE 'valid%'
		GROUP BY pc.emailaddress1

		--============================
		--CRM Accounts
		--============================
		INSERT INTO #Inserts (EmailPrimary,RecordSource,CreatedDate)

		SELECT pa.emailaddress1, 'CRM_Accounts' , MIN(pa.CopyLoadDate) CreatedDate
		FROM Predators_Reporting.prodcopy.Account pa (NOLOCK)
			JOIN dbo.DimCustomer dc (NOLOCK) ON dc.SSID = pa.accountid
			LEFT JOIN #prod prod ON prod.email = dc.EmailPrimary
		WHERE prod.Email IS NULL
			  AND dc.SourceSystem = 'CRM_Accounts'
			  AND dc.EmailPrimaryIsCleanStatus LIKE 'valid%'
		GROUP BY pa.emailaddress1
		
		--============================
		--FanMaker
		--============================

		INSERT INTO #Inserts (EmailPrimary,RecordSource,CreatedDate)

		SELECT fan.email, 'FanMaker' , MIN(fan.ETL__CreatedDate) CreatedDate
		FROM ods.FanMaker_Users fan (NOLOCK)
			JOIN dbo.DimCustomer dc (NOLOCK) ON dc.SSID = fan.email
			LEFT JOIN #prod prod ON prod.email = dc.EmailPrimary
		WHERE prod.Email IS NULL
			  AND dc.SourceSystem = 'FanMaker'
			  AND dc.EmailPrimaryIsCleanStatus LIKE 'valid%'
		GROUP BY fan.email

		/*==========================================================================================
											LOAD TO WORKING SET
		==========================================================================================*/

		CREATE INDEX IX_EmailPrimary ON #inserts (EmailPrimary)

		IF EXISTS (SELECT * 
				   FROM sys.indexes 
				   WHERE name='IX_EmailPrimary' AND object_id = OBJECT_ID('EmailOutbound.WorkingSet')
				   )
		BEGIN
			DROP INDEX IX_EmailPrimary ON EmailOutbound.WorkingSet
		END

		TRUNCATE TABLE EmailOutbound.WorkingSet

		INSERT INTO EmailOutbound.WorkingSet (EmailPrimary, IsNewRecord, RecordSource, CreatedDate)

		--Inserts
		--Uncertain how the steelers will want to resolve records coming in from multiple sources on the same
		--Date. SourceTieBreak Subquery put in place until confirmation from Steelers on how to handle
		SELECT EmailPrimary
			 , 1
			 , RecordSource
			 , CreatedDate
		FROM (
				SELECT inserts.EmailPrimary
					 , inserts.RecordSource
					 , inserts.CreatedDate 
					 , RANK() OVER(PARTITION BY inserts.EmailPrimary ORDER BY inserts.CreatedDate DESC , SourceRank) SourceRank
				FROM #Inserts inserts
					JOIN ( SELECT 'TM'				RecordSource	, 1 SourceRank 	UNION ALL
						   SELECT 'CRM_Accounts'	RecordSource	, 2 SourceRank	UNION ALL
						   SELECT 'CRM_Contacts'	RecordSource	, 3 SourceRank	UNION ALL
						   SELECT 'FanMaker'		RecordSource	, 4 SourceRank			
						 )SourceTieBreak ON SourceTieBreak.RecordSource = inserts.RecordSource
			 )x
		WHERE x.SourceRank = 1

		UNION ALL

		--Updates 
		SELECT Email
			  , 0
			  , NULL			--**FIELD NOT MODIFIED FOR EXISTING RECORDS
			  , NULL			--**FIELD NOT MODIFIED FOR EXISTING RECORDS
		FROM #prod

		--DECLARE @LoadCount INT
		SET @LoadCount = @@ROWCOUNT

		CREATE NONCLUSTERED INDEX IX_EmailPrimary ON EmailOutbound.WorkingSet (EmailPrimary)

		/*====================================================================================================
													LOG RESULTS
		====================================================================================================*/

		INSERT INTO EmailOutbound.Load_Monitoring (
		RunDate			--DATE
		,ProcName		--VARCHAR(100)
		,StartTime		--DATETIME
		,EndTime		--DATETIME
		,Completed		--BIT
		,LoadCount		--INT
		,ErrorMessage	--NVARCHAR(4000)
		,ErrorSeverity  --INT
		,ErrorState	    --INT
		)

		VALUES(
		@RunDate
		,@ProcName
		,@RunTime
		,GETDATE()
		,1
		,@LoadCount
		,NULL
		,NULL
		,NULL
		)

		DROP TABLE #prod
		DROP TABLE #Inserts

END TRY
/*========================================================================================================================
													START CATCH
========================================================================================================================*/

BEGIN CATCH

		/*====================================================================================================
													LOG ERRORS
		====================================================================================================*/

		SET @ErrorMessage  = ERROR_MESSAGE()	
		SET @ErrorSeverity = ERROR_SEVERITY()	
		SET @ErrorState	   = ERROR_STATE()	


		INSERT INTO EmailOutbound.Load_Monitoring (
		RunDate			--DATE
		,ProcName		--VARCHAR(100)
		,StartTime		--DATETIME
		,EndTime		--DATETIME
		,Completed		--BIT
		,LoadCount		--INT
		,ErrorMessage	--NVARCHAR(4000)
		,ErrorSeverity  --INT
		,ErrorState	    --INT
		)

		VALUES(
		@RunDate
		,@ProcName
		,@RunTime
		,GETDATE()
		,0
		,NULL
		,@ErrorMessage 
		,@ErrorSeverity
		,@ErrorState	  
		)

		DROP TABLE #prod
		DROP TABLE #Inserts

END CATCH


GO
