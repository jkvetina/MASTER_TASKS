CREATE OR REPLACE FORCE VIEW tsk_lov_statuses_bulk_v AS
SELECT
    t.status_id,
    t.status_name,
    t.is_default,
    t.is_colored,
    t.is_badge,
    b.project_name      AS group_name,
    --
    ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id ORDER BY t.order# NULLS LAST, t.row_order# NULLS LAST, t.status_id) AS order#
    --
FROM tsk_statuses t
JOIN tsk_lov_boards_bulk_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y'
WHERE t.is_active       = 'Y';
--
COMMENT ON TABLE tsk_lov_statuses_bulk_v IS '';

