CREATE OR REPLACE FORCE VIEW tsk_lov_owners_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_owner_id()      AS owner_id
    FROM DUAL
)
SELECT DISTINCT
    u.user_id,
    u.user_mail,
    u.user_name,
    u.user_name__,
    --
    CASE WHEN x.owner_id = u.user_id THEN 'Y' END AS is_current,
    --
    u.user_name AS order#
    --
FROM tsk_lov_users_v u
JOIN tsk_cards t
    ON t.owner_id       = u.user_id
JOIN tsk_available_projects_v a
    ON a.client_id      = t.client_id
    AND a.project_id    = t.project_id
JOIN x
    ON x.client_id      = a.client_id
    AND x.project_id    = a.project_id;
/

