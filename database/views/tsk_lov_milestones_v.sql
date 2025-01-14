CREATE OR REPLACE FORCE VIEW tsk_lov_milestones_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_number_item('P0_MILESTONE_ID') AS milestone_id
    FROM DUAL
)
SELECT
    t.milestone_id,
    t.milestone_name,
    --
    CASE WHEN x.milestone_id = t.milestone_id THEN 'Y' END AS is_current,
    --
    LPAD('0', ROW_NUMBER() OVER (
        PARTITION BY t.client_id, t.project_id
        ORDER BY t.order# NULLS LAST, t.milestone_name
        ), '0') AS order#
    --
FROM tsk_milestones t
CROSS JOIN x
JOIN tsk_lov_boards_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y'
WHERE t.is_active       = 'Y';
/

