CREATE OR REPLACE FORCE VIEW tsk_available_projects_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_board_id()      AS board_id
    FROM DUAL
)
SELECT
    a.app_id,
    a.user_id,
    a.client_id,
    a.client_name,
    p.project_id,
    p.project_name,
    p.is_active,
    p.is_default,
    --
    CASE WHEN x.project_id IS NOT NULL THEN 'Y' END AS is_current
    --
FROM tsk_available_clients_v a
JOIN tsk_projects p
    ON p.client_id      = a.client_id
    AND p.is_active     = 'Y'
LEFT JOIN x
    ON x.client_id      = p.client_id
    AND x.project_id    = p.project_id
/*
--
-- @TODO: need to map assigned projects
--
JOIN tsk_roles r
    ON r.client_id      = p.client_id
    AND (r.project_id   = p.project_id  OR r.project_id IS NULL)
    AND r.user_id       = c.user_id
    AND r.is_active     = 'Y'
*/
WHERE 1 = 1;
--
COMMENT ON TABLE tsk_available_projects_v IS '';

