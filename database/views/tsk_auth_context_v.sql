CREATE OR REPLACE FORCE VIEW tsk_auth_context_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_user_id()              AS user_id,
        core.get_app_id()               AS app_id,
        core.get_page_id()              AS page_id,
        --
        tsk_app.get_client_id()         AS client_id,
        tsk_app.get_project_id()        AS project_id,
        tsk_app.get_board_id()          AS board_id,
        --
        core.get_item('$SWIMLANE_ID')   AS swimlane_id,     -------- @TODO: create get_* + check for ID + switch to ID (number)?
        core.get_item('$OWNER_ID')      AS owner_id
        --
    FROM app_users_v u
    WHERE u.user_id = core.get_user_id()
)
SELECT DISTINCT
    x.user_id,
    x.app_id,
    x.page_id,
    b.client_id,
    b.project_id,
    b.board_id,
    x.swimlane_id,
    x.owner_id
    --
FROM x
JOIN tsk_available_boards_v b
    ON b.client_id      = x.client_id
    AND b.project_id    = x.project_id
    AND b.board_id      = x.board_id;
--
COMMENT ON TABLE tsk_auth_context_v IS '';

