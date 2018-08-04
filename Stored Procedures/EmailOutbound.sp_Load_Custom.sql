SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*============================================================================================================
CREATED BY:		Kaitlyn Sniffin
CREATED DATE:	8/14/2017
PY VERSION:		N/A
USED BY:		Emma Outbound Integration
UPDATES:		8/10 jbarberio - added in logging , modified logic to look use SSB_CRMSYSTEM_CONTACT_ID
DESCRIPTION:	This PROC updates the custom fields for EmailOutbound.UpsertSet, combining data from matching
				email addresses
NOTES:			Adapted from Jeff Barberio's sprocs for the Steelers outbound email integration.		
=============================================================================================================*/

CREATE PROC [EmailOutbound].[sp_Load_Custom]

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


		/*====================================================================================================
												   INSERT FROM WORKING SET
		====================================================================================================*/
		
		IF EXISTS (SELECT * 
				   FROM sys.indexes 
				   WHERE name='IX_Email' AND object_id = OBJECT_ID('EmailOutbound.Upsert_Custom')
				   )
		BEGIN
			DROP INDEX IX_Email ON EmailOutbound.Upsert_Custom
		END

		TRUNCATE TABLE EmailOutbound.Upsert_Custom

		INSERT INTO EmailOutbound.Upsert_custom (SSB_CRMSYSTEM_CONTACT_ID, email)

		SELECT SSB_CRMSYSTEM_CONTACT_ID
			  ,Email
		FROM (SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID 
					,wrk.EmailPrimary Email
					,RANK() OVER(PARTITION BY dc.EmailPrimary ORDER BY SourceRank , dc.UpdatedDate , dc.CreatedDate, dc.DimCustomerId) RecordRank 
			  FROM dimcustomer dc
				JOIN EmailOutbound.WorkingSet wrk ON wrk.EmailPrimary = dc.EmailPrimary
				JOIN dimcustomerssbid ssbid ON ssbid.DimCustomerId = dc.DimCustomerID						
				JOIN ( SELECT 'TM'				SourceSystem	, 1 SourceRank 	UNION ALL
					   SELECT 'CRM_Accounts'	SourceSystem	, 2 SourceRank	UNION ALL
					   SELECT 'CRM_Contacts'	SourceSystem	, 3 SourceRank	UNION ALL
					   SELECT 'FanMaker'		SourceSystem	, 4 SourceRank	
					 )SourceRank ON SourceRank.SourceSystem = dc.SourceSystem
			  )x
		WHERE x.RecordRank = 1

		SET @LoadCount = @@ROWCOUNT

		/*==================================================================================================
													UPDATE CUSTOM FIELDS
		==================================================================================================*/

		--================================
		--Emma Custom Extended Attributes
		--================================
		INSERT INTO EmailOutbound.Upsert_Custom
		(
		    SSB_CRMSYSTEM_CONTACT_ID,
		    Email,
		    Custom1,
		    Custom2,
		    Custom3,
		    Custom4,
		    Custom5,
		    Custom6,
		    Custom7,
		    Custom8,
		    Custom9,
		    Custom10,
		    Updated_Date
		)
		
	SELECT x.SSB_CRMSYSTEM_CONTACT_ID
		, x.Email
		, x.Custom1
		, x.Custom2
        , x.Custom3
        , x.Custom4
        , x.Custom5
        , x.Custom6
        , x.Custom7
        , x.Custom8
        , x.Custom9
        , x.Custom10
		, x.ModifiedDate
	FROM (
			SELECT base.SSB_CRMSYSTEM_CONTACT_ID
				, base.Email
				, pe.Custom1
				, pe.Custom2
				, pe.Custom3
				, pe.Custom4
				, pe.Custom5
				, pe.Custom6
				, pe.Custom7
				, pe.Custom8
				, pe.Custom9
				, pe.Custom10
				, pe.ModifiedDate
				,RANK() OVER(PARTITION BY base.Email ORDER BY ssbid.IsDeleted DESC, SourceRank.SourceRank, pe.ModifiedDate, ssbid.UpdatedDate, ssbid.DimCustomerId) RecordRank
			FROM EmailOutbound.Upsert_Standard base
			JOIN dbo.dimcustomerssbid ssbid
				ON base.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
			JOIN pred.Emma_ExtendedAttributes pe
				ON ssbid.DimCustomerID = pe.DimCustomerId
			JOIN (	SELECT 'TM'				SourceSystem	, 1 SourceRank 	UNION ALL
					SELECT 'CRM_Accounts'	SourceSystem	, 2 SourceRank	UNION ALL
					SELECT 'CRM_Contacts'	SourceSystem	, 3 SourceRank	UNION ALL
					SELECT 'FanMaker'		SourceSystem	, 4 SourceRank		
				)SourceRank ON SourceRank.SourceSystem = ssbid.SourceSystem
		)x
	WHERE x.RecordRank = 1
		



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

END CATCH










GO
