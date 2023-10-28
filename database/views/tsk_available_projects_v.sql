CREATE OR REPLACE FORCE VIEW tsk_available_projects_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        u.app_id,
        u.user_id,
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_board_id()      AS board_id
        --
    FROM app_user_v u
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
    CASE WHEN p.client_id   = x.client_id   THEN 'Y' END AS is_current_client,
    CASE WHEN p.project_id  = x.project_id  THEN 'Y' END AS is_current,
    --
    LPAD(ROW_NUMBER() OVER (PARTITION BY a.client_id ORDER BY p.project_name), 4, '0') AS order#
    --
FROM tsk_available_clients_v a
CROSS JOIN x
JOIN tsk_projects p
    ON p.client_id      = a.client_id
    AND p.is_active     = 'Y';
--
COMMENT ON TABLE tsk_available_projects_v IS '';

