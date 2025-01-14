CREATE OR REPLACE FORCE VIEW tsk_p105_tags_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        t.card_id
    FROM tsk_p100_cards_v t
    WHERE t.card_id = core.get_number_item('$CARD_ID')
--),
--g AS (
--    SELECT /*+ MATERIALIZE */
--        t.card_id,
--        i.COLUMN_VALUE AS tag
--    FROM t
--    CROSS JOIN APEX_STRING.SPLIT(LTRIM(RTRIM(t.tags, ':'), ':'), ':') i
)
SELECT
    t.card_id,
    --
    '#' || t.card_id || ' ' || t.card_name || ' ' || t.card_progress AS list_text,
    --
    t.updated_at || ' ' || t.updated_by AS list_supplemental,
    --
    NULL                AS list_counter,
    t.card_link         AS list_link
    --
FROM tsk_p100_cards_v t;
/

