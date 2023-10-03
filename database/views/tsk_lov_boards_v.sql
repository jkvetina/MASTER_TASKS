CREATE OR REPLACE FORCE VIEW tsk_lov_boards_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_board_id()      AS board_id
    FROM DUAL
)
SELECT
    t.client_id,
    t.client_name,
    t.project_id,
    t.project_name,
    t.board_id,
    t.board_name,
    --
    ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id ORDER BY t.order#, t.board_name) AS order#,
    --
    t.is_favorite,
    --
    CASE WHEN t.board_id = x.board_id THEN 'Y' END AS is_current
    --
FROM tsk_available_boards_v t
JOIN x
    ON x.client_id      = t.client_id
    AND x.project_id    = t.project_id;
--
COMMENT ON TABLE tsk_lov_boards_v IS '';

