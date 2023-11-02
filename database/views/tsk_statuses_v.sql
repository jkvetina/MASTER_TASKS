CREATE OR REPLACE FORCE VIEW tsk_statuses_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_board_id()      AS board_id
    FROM DUAL
),
c AS (
    SELECT
        t.status_id,
        --
        SUM(CASE WHEN t.board_id    = x.board_id    THEN 1 ELSE 0 END) AS count_board,
        SUM(CASE WHEN t.project_id  = x.project_id  THEN 1 ELSE 0 END) AS count_project,
        SUM(CASE WHEN t.client_id   = x.client_id   THEN 1 ELSE 0 END) AS count_client
    FROM tsk_cards t
    JOIN tsk_available_projects_v a
        ON a.client_id      = t.client_id
        AND a.project_id    = t.project_id
    JOIN x
        ON x.client_id      = a.client_id
        AND x.project_id    = a.project_id
    GROUP BY t.status_id
)
SELECT
    t.client_id         AS old_client_id,
    t.project_id        AS old_project_id,
    t.status_id         AS old_status_id,
    --
    t.client_id,
    t.project_id,
    t.status_id,
    t.status_name,
    t.status_group,
    t.col_order#,
    t.row_order#,
    t.is_active,
    t.is_default,
    t.is_colored,
    t.is_badge,
    --
    c.count_board,
    c.count_project,
    c.count_client
    --
FROM tsk_statuses t
JOIN tsk_available_projects_v a
    ON a.client_id      = t.client_id
    AND a.project_id    = t.project_id
JOIN x
    ON x.client_id      = a.client_id
    AND x.project_id    = a.project_id
LEFT JOIN c
    ON c.status_id      = t.status_id;
--
COMMENT ON TABLE tsk_statuses_v IS '';

