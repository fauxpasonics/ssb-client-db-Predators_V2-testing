SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ismail Fuseini
-- Create date: 11/29/2016
-- Description:	Load FanMaker Users sProc
-- =============================================
CREATE PROCEDURE [apietl].[Load_FanMaker_Users_Old]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE ods.FanMaker_Users AS TARGET
        USING
            (
              SELECT    CAST(ud.created_at AS DATETIME2) AS ETL__CreatedDate
                      , GETDATE() AS ETL__UpdatedDate
                      , ud.email
                      , ud.email_deliverable
                      , ud.first_name
                      , ud.last_name
                      , ud.fanfluence
                      , ud.profile_url
                      , ud.gender
                      , ud.age
                      , ud.relationship_status
                      , ud.religion
                      , ud.political
                      , ud.location
                      , ud.address
                      , ud.city
                      , ud.state
                      , ud.zip
                      , ud.birthdate
                      , ud.phone
                      , CAST(ud.created_at AS DATETIME2) AS created_at
                      , ud.tc_accepted_at
                      , CAST(ud.points_available AS INT) AS points_available
                      , CAST(ud.points_spent AS INT) AS points_spent
                      , CAST(ud.total_points_earned AS INT) AS total_points_earned
                      , CAST(ud.social_points AS INT) AS social_points
                      , CAST(ud.ticketing_points AS INT) AS ticketing_points
                      , ud.membership_assignment
                      , CAST(ud.ticketing_spend AS DECIMAL(13, 4)) AS ticketing_spend
                      , CAST(ud.pos_points AS INT) AS pos_points
                      , CAST(ud.pos_spend AS DECIMAL(13, 4)) AS pos_spend
              FROM      apietl.fanmaker_userinfo_data_1 AS ud
            ) AS SOURCE
        ON ( TARGET.created_at = SOURCE.created_at
             AND TARGET.email = SOURCE.email
           )
        WHEN MATCHED THEN
            UPDATE SET
                    TARGET.email_deliverable = SOURCE.email_deliverable
                  , TARGET.first_name = SOURCE.first_name
                  , TARGET.last_name = SOURCE.last_name
                  , TARGET.fanfluence = SOURCE.fanfluence
                  , TARGET.profile_url = SOURCE.profile_url
                  , TARGET.gender = SOURCE.gender
                  , TARGET.age = SOURCE.age
                  , TARGET.relationship_status = SOURCE.relationship_status
                  , TARGET.religion = SOURCE.religion
                  , TARGET.political = SOURCE.political
                  , TARGET.location = SOURCE.location
                  , TARGET.address = SOURCE.address
                  , TARGET.city = SOURCE.city
                  , TARGET.state = SOURCE.state
                  , TARGET.zip = SOURCE.zip
                  , TARGET.birthdate = SOURCE.birthdate
                  , TARGET.phone = SOURCE.phone
                  , TARGET.created_at = SOURCE.created_at
                  , TARGET.tc_accepted_at = SOURCE.tc_accepted_at
                  , TARGET.points_available = SOURCE.points_available
                  , TARGET.points_spent = SOURCE.points_spent
                  , TARGET.total_points_earned = SOURCE.total_points_earned
                  , TARGET.social_points = SOURCE.social_points
                  , TARGET.ticketing_points = SOURCE.ticketing_points
                  , TARGET.membership_assignment = SOURCE.membership_assignment
                  , TARGET.ticketing_spend = SOURCE.ticketing_spend
                  , TARGET.pos_points = SOURCE.pos_points
                  , TARGET.pos_spend = SOURCE.pos_spend
        WHEN NOT MATCHED THEN
            INSERT ( ETL__CreatedDate
                   , ETL__UpdatedDate
                   , email
                   , email_deliverable
                   , first_name
                   , last_name
                   , fanfluence
                   , profile_url
                   , gender
                   , age
                   , relationship_status
                   , religion
                   , political
                   , location
                   , address
                   , city
                   , state
                   , zip
                   , birthdate
                   , phone
                   , created_at
                   , tc_accepted_at
                   , points_available
                   , points_spent
                   , total_points_earned
                   , social_points
                   , ticketing_points
                   , membership_assignment
                   , ticketing_spend
                   , pos_points
                   , pos_spend
	               )
            VALUES ( SOURCE.ETL__CreatedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.email
                   , SOURCE.email_deliverable
                   , SOURCE.first_name
                   , SOURCE.last_name
                   , SOURCE.fanfluence
                   , SOURCE.profile_url
                   , SOURCE.gender
                   , SOURCE.age
                   , SOURCE.relationship_status
                   , SOURCE.religion
                   , SOURCE.political
                   , SOURCE.location
                   , SOURCE.address
                   , SOURCE.city
                   , SOURCE.state
                   , SOURCE.zip
                   , SOURCE.birthdate
                   , SOURCE.phone
                   , SOURCE.created_at
                   , SOURCE.tc_accepted_at
                   , SOURCE.points_available
                   , SOURCE.points_spent
                   , SOURCE.total_points_earned
                   , SOURCE.social_points
                   , SOURCE.ticketing_points
                   , SOURCE.membership_assignment
                   , SOURCE.ticketing_spend
                   , SOURCE.pos_points
                   , SOURCE.pos_spend
                   );
    END;


GO
