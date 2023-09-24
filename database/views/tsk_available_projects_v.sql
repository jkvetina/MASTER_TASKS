CREATE OR REPLACE FORCE VIEW tsk_available_projects_v AS
SELECT
    a.app_id,
    a.user_id,
    a.client_id,
    a.client_name,
    p.project_id,
    p.project_name,
    p.is_active,
    p.is_default
    --
FROM tsk_available_clients_v a
JOIN tsk_projects p
    ON p.client_id      = a.client_id
    AND p.is_active     = 'Y'
WHERE 1 = 1;
--
COMMENT ON TABLE tsk_available_projects_v IS '';

