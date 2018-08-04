SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ismail Fuseini
-- Create date: 11/29/2016
-- Description:	Loaf FanMaker Activities sProc
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_Activities_Old]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE ods.FanMaker_Activities AS TARGET
        USING
            (
              SELECT    uda.created_at AS ETL__CreatedDate
                      , GETDATE() AS ETL__UpdatedDate
                      , ud.email
                      , uda.[identity]
                      , uda.type
                      , uda.subtype
                      , uda.subject
                      , CAST(uda.created_at AS DATETIME2) created_at
                      , uda.source_url
                      , CAST(uda.worth AS INT) worth
                      , CAST(uda.awarded AS INT) awarded
              FROM      apietl.fanmaker_userinfo_data_activities_2 AS uda
                        INNER JOIN apietl.fanmaker_userinfo_data_1 AS ud ON ud.fanmaker_userinfo_data_id = uda.fanmaker_userinfo_data_id
            ) AS SOURCE
        ON ( TARGET.ETL__CreatedDate = SOURCE.ETL__CreatedDate
             AND TARGET.email = SOURCE.email
             AND TARGET.[identity] = SOURCE.[identity]
           )
        WHEN NOT MATCHED THEN
            INSERT (  ETL__CreatedDate
                   , ETL__UpdatedDate
                   , email
                   , [identity]
                   , type
                   , subtype
                   , subject
                   , created_at
                   , source_url
                   , worth
                   , awarded
	               )
            VALUES ( SOURCE.ETL__CreatedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.email
                   , SOURCE.[identity]
                   , SOURCE.type
                   , SOURCE.subtype
                   , SOURCE.subject
                   , SOURCE.created_at
                   , SOURCE.source_url
                   , SOURCE.worth
                   , SOURCE.awarded
                   );
	END


GO
