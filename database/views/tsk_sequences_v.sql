CREATE OR REPLACE FORCE VIEW tsk_sequences_v AS
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
    t.sequence_id,
    t.sequence_desc,
    t.order#,
    t.is_active
    --
FROM tsk_sequences t
JOIN tsk_available_projects_v a
    ON a.client_id      = t.client_id
    AND a.project_id    = t.project_id
JOIN x
    ON x.client_id      = a.client_id
    AND x.project_id    = a.project_id;
/

