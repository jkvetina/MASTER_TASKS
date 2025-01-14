CREATE OR REPLACE FORCE VIEW tsk_lov_boards_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
    FROM DUAL
)
SELECT
    t.client_id,
    t.client_name,
    t.project_id,
    t.project_name,
    t.board_id,
    t.board_name,
    t.board_order#      AS order#,
    --
    t.is_simple,
    t.is_favorite,
    t.is_current
    --
FROM tsk_available_boards_v t
JOIN x
    ON x.client_id      = t.client_id
    AND x.project_id    = t.project_id;
/

