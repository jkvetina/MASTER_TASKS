CREATE OR REPLACE FORCE VIEW tsk_available_boards_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_context_app()  AS app_id,
        core.get_user_id()      AS user_id,
        --
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
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
    --
    f.swimlane_id       AS fav_swimlane_id,
    f.owner_id          AS fav_owner_id,
    --
    b.is_simple,
    b.is_active,
    b.is_default,
    --
    CASE WHEN f.board_id IS NOT NULL THEN 'Y' END AS is_favorite,
    --
    CASE WHEN b.client_id   = x.client_id                                   THEN 'Y' END AS is_current_client,
    CASE WHEN b.client_id   = x.client_id AND b.project_id = x.project_id   THEN 'Y' END AS is_current_project,
    CASE WHEN b.client_id   = x.client_id AND b.board_id    = x.board_id    THEN 'Y' END AS is_current,
    --
    LPAD(ROW_NUMBER() OVER (ORDER BY b.order# NULLS LAST, b.board_name), 4, '0') AS board_order#,
    b.order#
    --
FROM tsk_available_projects_v a
CROSS JOIN x
JOIN tsk_boards b
    ON b.client_id      = a.client_id
    AND b.project_id    = a.project_id
    AND b.is_active     = 'Y'
LEFT JOIN tsk_boards_fav f
    ON f.user_id        = a.user_id
    AND f.client_id     = b.client_id
    AND f.project_id    = b.project_id
    AND f.board_id      = b.board_id;
/

