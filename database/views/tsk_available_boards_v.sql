CREATE OR REPLACE FORCE VIEW tsk_available_boards_v AS
SELECT
    a.client_id,
    a.client_name,
    a.project_id,
    a.project_name,
    b.board_id,
    b.board_name,
    b.order#,
    --
    CASE WHEN f.board_id IS NOT NULL THEN 'Y' END AS is_favorite
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
    AND f.board_id      = b.board_id;
--
COMMENT ON TABLE tsk_available_boards_v IS '';

