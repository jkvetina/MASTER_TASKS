CREATE OR REPLACE FORCE VIEW tsk_sequences_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_item('P0_CLIENT_ID')   AS client_id
    FROM DUAL
)
SELECT
    t.client_id         AS old_client_id,
    t.sequence_id       AS old_sequence_id,
    --
    t.client_id,
    t.sequence_id,
    t.sequence_desc,
    t.order#,
    t.is_active
    --
FROM tsk_sequences t
JOIN tsk_available_clients_v a
    ON a.client_id      = t.client_id
JOIN x
    ON x.client_id      = a.client_id;
/

