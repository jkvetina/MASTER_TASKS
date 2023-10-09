CREATE OR REPLACE FORCE VIEW tsk_available_boards_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_board_id()      AS board_id
    FROM DUAL
)
SELECT
    a.client_id,
    a.client_name,
    a.project_id,
    a.project_name,
    b.board_id,
    b.board_name,
    b.sequence_id,
    b.is_active,
    b.is_default,
    b.order#,
    --
    CASE WHEN f.board_id IS NOT NULL THEN 'Y' END AS is_favorite,
    CASE WHEN x.board_id IS NOT NULL THEN 'Y' END AS is_current
    --
FROM tsk_available_projects_v a
JOIN tsk_boards b
    ON b.client_id      = a.client_id
    AND b.project_id    = a.project_id
    AND b.is_active     = 'Y'
LEFT JOIN tsk_boards_fav f
    ON f.user_id        = a.user_id
    AND f.client_id     = b.client_id
    AND f.project_id    = b.project_id
    AND f.board_id      = b.board_id
LEFT JOIN x
    ON x.client_id      = b.client_id
    AND x.project_id    = b.project_id
    AND x.board_id      = b.board_id;
--
COMMENT ON TABLE tsk_available_boards_v IS '';

