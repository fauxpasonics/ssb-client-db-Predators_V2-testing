SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [ods].[TM_vw_TicketReturn_Files] AS (

SELECT *
FROM ods.tm_tkt (NOLOCK)
WHERE ticket_status = 'R'

UNION 

SELECT *
FROM ods.tm_plans (NOLOCK)
WHERE ticket_status = 'R'

)









GO
