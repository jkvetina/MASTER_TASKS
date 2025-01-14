CREATE OR REPLACE FORCE VIEW tsk_lov_repos_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
    FROM DUAL
)
SELECT
    r.repo_id
FROM tsk_repos r
JOIN tsk_lov_projects_v p   -- using tsk_auth_available_projects_v
    ON p.client_id          = r.client_id
    AND p.project_id        = r.project_id
JOIN x
    ON x.client_id          = r.client_id
    AND (x.project_id       = r.project_id  OR x.project_id IS NULL);
/

