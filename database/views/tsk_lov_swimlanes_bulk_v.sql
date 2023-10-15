CREATE OR REPLACE FORCE VIEW tsk_lov_swimlanes_bulk_v AS
SELECT
    t.swimlane_id,
    t.swimlane_name,
    b.project_name || CASE WHEN t.is_active = 'Y' THEN ' (Active)' ELSE ' (Not Active)' END AS group_name,
    --
    ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id ORDER BY t.order# NULLS LAST, t.swimlane_name) AS order#
    --
FROM tsk_swimlanes t
JOIN tsk_lov_boards_bulk_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y';
--
COMMENT ON TABLE tsk_lov_swimlanes_bulk_v IS '';

