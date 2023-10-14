CREATE OR REPLACE FORCE VIEW tsk_p105_checklist_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        t.card_id
    FROM tsk_p100_cards_v t
    WHERE t.card_id = core.get_item('P105_CARD_ID')
)
SELECT
    t.card_id,
    t.checklist_id,
    --
    LTRIM(t.order# || ' ') || t.checklist_item AS checklist_item,
    --
    t.checklist_done,
    t.order#,
    --
    ROW_NUMBER() OVER (ORDER BY order# NULLS LAST, checklist_done NULLS LAST, checklist_item, checklist_id) AS grid_order
    --
FROM tsk_card_checklist t
JOIN x
    ON x.card_id    = t.card_id
UNION ALL
--
SELECT
    NULL        AS card_id,
    -1          AS checklist_id,
    NULL        AS checklist_item,
    NULL        AS checklist_done,
    NULL        AS order#,
    NULL        AS grid_order
FROM DUAL;
--
COMMENT ON TABLE tsk_p105_checklist_v IS '';

