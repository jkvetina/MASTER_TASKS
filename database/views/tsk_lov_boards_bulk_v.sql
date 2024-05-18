CREATE OR REPLACE FORCE VIEW tsk_lov_boards_bulk_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()             AS client_id,
        core.get_item('$PROJECT_ID')        AS project_id,
        core.get_number_item('$BOARD_ID')   AS board_id
    FROM DUAL
)
SELECT
    t.client_id,
    t.client_name,
    t.project_id,
    t.project_name,
    t.board_id,
    t.board_name,
    t.project_name      AS group_name,
    t.board_order#      AS order#,
    --
    t.is_favorite,
    --
    CASE WHEN t.board_id = x.board_id THEN 'Y' END AS is_current
    --
FROM tsk_available_boards_v t
JOIN x
    ON x.client_id      = t.client_id
    AND x.project_id    = t.project_id;
/

