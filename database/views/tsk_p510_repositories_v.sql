CREATE OR REPLACE FORCE VIEW tsk_p510_repositories_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
    FROM DUAL
)
SELECT
    t.client_id,
    t.project_id,
    t.repo_id,
    t.branch_id,
    t.api_type,
    t.api_token,
    t.last_synced_at
    --
FROM tsk_repos t
JOIN x
    ON x.client_id      = t.client_id
    AND (x.project_id   = t.project_id  OR x.project_id IS NULL);
/

