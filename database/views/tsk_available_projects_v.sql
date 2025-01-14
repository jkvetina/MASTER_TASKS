CREATE OR REPLACE FORCE VIEW tsk_available_projects_v AS
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
/

