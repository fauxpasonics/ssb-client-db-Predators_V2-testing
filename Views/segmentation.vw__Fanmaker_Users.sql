SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [segmentation].[vw__Fanmaker_Users]
AS

(SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, f.Email
	, f.Email_Deliverable EmailDeliverable
	, f.first_name FanmakerFirstName
	, f.last_name FanmakerLastName
	, f.Fanfluence
	, f.profile_url ProfileURL
	, f.Gender
	, f.Age
	, f.relationship_status RelationshipStatus
	, f.Religion
	, f.Political
	, f.[Location]
	, f.[Address]
	, f.City
	, f.[State]
	, f.Zip
	, f.Birthdate
	, f.Phone
	, f.created_at CreatedAt
	, f.tc_accepted_at TCAcceptedAt
	, f.points_available PointsAvailable
	, f.points_spent PointsSpent
	, f.total_points_earned TotalPointsEarned
	, f.social_points SocialPoints
	, f.ticketing_points TicketingPoints
	, f.ticketing_spend TicketingSpend
	, f.pos_points POSPoints
	, f.pos_spend POSSpend
FROM ods.FanMaker_Users f (NOLOCK)
JOIN dbo.DimCustomer dc (NOLOCK) ON f.email = dc.SSID
JOIN dbo.DimCustomerssbid ssbid (NOLOCK) ON dc.DimCustomerId = ssbid.DimCustomerId
)
GO
