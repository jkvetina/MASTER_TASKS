CREATE OR REPLACE FORCE VIEW tsk_lov_sequences_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
    FROM DUAL
)
SELECT
    t.sequence_id,
    t.sequence_desc,
    --
    LPAD('0', ROW_NUMBER() OVER (ORDER BY t.order# NULLS LAST, t.sequence_id), '0') AS order#
    --
FROM tsk_sequences t
JOIN x
    ON x.client_id      = t.client_id
    AND x.project_id    = t.project_id
WHERE t.is_active       = 'Y';
/

