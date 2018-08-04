SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ismail Fuseini
-- Create date: 11/29/2016
-- Description:	Load FanMaker Social Media Handles sSproc
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_Social_Old] 
	-- Add the parameters for the stored procedure here
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE ods.FanMaker_Social AS TARGET
        USING
            (
              SELECT    GETDATE() AS ETL__UpdatedDate
                      , ud.email
                      , udsh.twitter
                      , udsh.foursquare
                      , udsh.facebook
                      , udsh.instagram
                      , udsh.tvtag
                      , udsh.shopify
                      , udsh.pinterest
                      , udsh.tumblr
              FROM      apietl.fanmaker_userinfo_data_social_handles_2 AS udsh
                        INNER JOIN apietl.fanmaker_userinfo_data_1 AS ud ON ud.fanmaker_userinfo_data_id = udsh.fanmaker_userinfo_data_id
            ) AS SOURCE
        ON ( TARGET.email = SOURCE.email )
        WHEN MATCHED THEN
            UPDATE SET
                    TARGET.ETL__UpdatedDate = SOURCE.ETL__UpdatedDate
                  , TARGET.twitter = SOURCE.twitter
                  , TARGET.foursquare = SOURCE.foursquare
                  , TARGET.facebook = SOURCE.facebook
                  , TARGET.instagram = SOURCE.instagram
                  , TARGET.tvtag = SOURCE.tvtag
                  , TARGET.shopify = SOURCE.shopify
                  , TARGET.pinterest = SOURCE.pinterest
                  , TARGET.tumblr = SOURCE.tumblr
        WHEN NOT MATCHED THEN
            INSERT ( ETL__UpdatedDate
                   , email
                   , twitter
                   , foursquare
                   , facebook
                   , instagram
                   , tvtag
                   , shopify
                   , pinterest
                   , tumblr
                   )
            VALUES ( SOURCE.ETL__UpdatedDate
                   , SOURCE.email
                   , SOURCE.twitter
                   , SOURCE.foursquare
                   , SOURCE.facebook
                   , SOURCE.instagram
                   , SOURCE.tvtag
                   , SOURCE.shopify
                   , SOURCE.pinterest
                   , SOURCE.tumblr
                   );
    END;


GO
