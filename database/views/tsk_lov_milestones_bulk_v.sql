CREATE OR REPLACE FORCE VIEW tsk_lov_milestones_bulk_v AS
SELECT
    t.milestone_id,
    t.milestone_name,
    b.project_name || CASE WHEN t.is_active = 'Y' THEN ' (Active)' ELSE ' (Not Active)' END AS group_name,
    --
    LPAD('0', ROW_NUMBER() OVER (
        PARTITION BY t.client_id, t.project_id
        ORDER BY t.order# NULLS LAST, t.milestone_name
        ), '0') AS order#
    --
FROM tsk_milestones t
JOIN tsk_lov_boards_bulk_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y';
/

