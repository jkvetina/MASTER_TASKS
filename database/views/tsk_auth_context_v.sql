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
        core.get_item('$CLIENT_ID')     AS page_client_id,
        core.get_item('$PROJECT_ID')    AS page_project_id,
        core.get_item('$BOARD_ID')      AS page_board_id,
        core.get_item('$SWIMLANE_ID')   AS page_swimlane_id,
        core.get_item('$OWNER_ID')      AS page_owner_id
        --
    FROM tsk_users u
    WHERE u.user_id         = core.get_user_id()
        AND u.is_active     = 'Y'
)
SELECT
    x.user_id,
    x.app_id,
    x.page_id,
    --
    MAX(c.client_id)    AS client_id,
    MAX(p.project_id)   AS project_id,
    MAX(b.board_id)     AS board_id,
    --
    MAX(d.client_id)            AS page_client_id,
    MAX(j.project_id)           AS page_project_id,
    MAX(o.board_id)             AS page_board_id,
    MAX(x.page_swimlane_id)     AS page_swimlane_id,
    MAX(x.page_owner_id)        AS page_owner_id
    --
FROM x
LEFT JOIN tsk_auth_available_projects_v c   ON c.client_id = x.client_id
LEFT JOIN tsk_auth_available_projects_v p   ON p.client_id = x.client_id        AND p.project_id = x.project_id
LEFT JOIN tsk_auth_available_boards_v b     ON b.client_id = x.client_id        AND b.project_id = x.project_id         AND b.board_id = x.board_id
LEFT JOIN tsk_auth_available_projects_v d   ON d.client_id = x.page_client_id
LEFT JOIN tsk_auth_available_projects_v j   ON j.client_id = x.page_client_id   AND j.project_id = x.page_project_id
LEFT JOIN tsk_auth_available_boards_v o     ON o.client_id = x.page_client_id   AND o.project_id = x.page_project_id    AND o.board_id = x.page_board_id
GROUP BY
    x.user_id,
    x.app_id,
    x.page_id;
/

