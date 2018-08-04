SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [ods].[TM_vw_TicketActive_Files] AS (

SELECT tkt.*, 'tkt' SourceTable
FROM ods.tm_tkt (NOLOCK) tkt
INNER JOIN ods.TM_Evnt e ON tkt.event_id = e.Event_id
WHERE tkt.ticket_status <> 'R'
AND e.[Plan] <> 'Y'
AND tkt.event_id <> tkt.plan_event_id

UNION ALL

SELECT plans.*, 'plan' SourceTable
FROM ods.tm_plans (NOLOCK) plans 
LEFT OUTER JOIN (SELECT * FROM ods.tm_tkt (NOLOCK) WHERE event_id <> plan_event_id) tkt
	ON plans.acct_id = tkt.acct_id 
	AND plans.ticket_status = tkt.ticket_status
	AND plans.plan_event_id = tkt.plan_event_id
	AND plans.section_id = tkt.section_id
	AND plans.row_id = tkt.row_id
	AND plans.seat_num = tkt.seat_num
	AND plans.num_seats = tkt.num_seats
WHERE tkt.id IS NULL AND plans.ticket_status <> 'R'

)












GO
