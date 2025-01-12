CREATE OR REPLACE FORCE VIEW tsk_lov_swimlanes_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_item('P0_SWIMLANE_ID') AS swimlane_id
    FROM DUAL
)
SELECT
    t.swimlane_id,
    t.swimlane_name,
    --
    CASE WHEN x.swimlane_id = t.swimlane_id THEN 'Y' END AS is_current,
    --
    LPAD('0', ROW_NUMBER() OVER (
        PARTITION BY t.client_id, t.project_id
        ORDER BY t.order# NULLS LAST, t.swimlane_name
        ), '0') AS order#
    --
FROM tsk_swimlanes t
CROSS JOIN x
JOIN tsk_lov_boards_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y'
WHERE t.is_active       = 'Y';
/

