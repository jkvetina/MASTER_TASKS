CREATE OR REPLACE FORCE VIEW tsk_lov_statuses_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_item('P0_STATUS_ID')   AS status_id
    FROM DUAL
)
SELECT
    t.status_id,
    t.status_name,
    t.status_group,
    t.is_default,
    t.is_colored,
    t.is_badge,
    --
    CASE WHEN x.status_id = t.status_id THEN 'Y' END AS is_current,
    --
    LPAD('0', ROW_NUMBER() OVER (
        PARTITION BY
            t.client_id,
            t.project_id
        ORDER BY
            t.col_order# NULLS LAST,
            t.row_order# NULLS LAST,
            t.status_id
        ), '0') AS order#,
    --
    t.col_order#,
    t.row_order#
    --
FROM tsk_statuses t
CROSS JOIN x
JOIN tsk_lov_boards_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y'
WHERE t.is_active       = 'Y';
/

