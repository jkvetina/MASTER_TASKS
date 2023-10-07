CREATE OR REPLACE FORCE VIEW tsk_p105_files_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        t.card_id
    FROM tsk_p100_cards_v t
    WHERE t.card_id = core.get_item('P105_CARD_ID')
)
SELECT
    f.file_id,
    f.file_name,
    f.file_size,
    f.updated_by,
    TO_CHAR(f.updated_at, 'YYYY-MM-DD HH24:MI') AS updated_at,
    --
    NULL AS download_link,
    NULL AS delete_link
    --
FROM tsk_card_files f
JOIN x
    ON x.card_id = f.card_id;
--
COMMENT ON TABLE tsk_p105_files_v IS '';

