CREATE OR REPLACE FORCE VIEW tsk_milestones_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
    FROM DUAL
),
c AS (
    SELECT /*+ MATERIALIZE */
        t.milestone_id,
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
    GROUP BY
        t.milestone_id
)
SELECT
    t.client_id,
    t.project_id,
    t.milestone_id,
    t.milestone_name,
    t.order#,
    t.is_active,
    --
    c.count_board,
    c.count_project,
    c.count_client
    --
FROM tsk_milestones t
JOIN tsk_available_projects_v a
    ON a.client_id      = t.client_id
    AND a.project_id    = t.project_id
JOIN x
    ON x.client_id      = a.client_id
    AND x.project_id    = a.project_id
LEFT JOIN c
    ON c.milestone_id    = t.milestone_id;
/

