CREATE OR REPLACE FORCE VIEW tsk_lov_projects_v AS
SELECT
    t.client_id,
    t.client_name,
    t.project_id,
    t.project_name,
    --
    ROW_NUMBER() OVER (PARTITION BY t.client_id ORDER BY t.project_name, t.project_id) AS order#
    --
FROM tsk_available_projects_v t;
--
COMMENT ON TABLE tsk_lov_projects_v IS '';

