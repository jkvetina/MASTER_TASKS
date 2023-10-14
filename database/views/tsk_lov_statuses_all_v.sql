CREATE OR REPLACE FORCE VIEW tsk_lov_statuses_all_v AS
SELECT
    t.status_id,
    t.status_name,
    t.is_default,
    t.is_colored,
    t.is_badge,
    --
    ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id ORDER BY t.order# NULLS LAST, t.status_id) AS order#,
    --
    CASE WHEN t.is_active = 'Y' THEN 'Active' ELSE 'Not Active' END AS group_name
    --
FROM tsk_statuses t
JOIN tsk_lov_boards_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y';
--
COMMENT ON TABLE tsk_lov_statuses_all_v IS '';

