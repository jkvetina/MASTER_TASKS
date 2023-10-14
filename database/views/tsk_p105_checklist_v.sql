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
    t.checklist_done,
    t.order#,
    --
    LTRIM(t.order# || ' ') || t.checklist_item AS checklist_item,
    --
    'LEVEL' || NULLIF(REGEXP_COUNT(RTRIM(t.order#, '.'), '\.'), 0) AS css_class,
    --
    ROW_NUMBER() OVER (ORDER BY t.order# NULLS LAST, t.checklist_done NULLS LAST, t.checklist_item, t.checklist_id) AS grid_order
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
    NULL        AS css_class,
    NULL        AS order#,
    NULL        AS grid_order
FROM DUAL;
--
COMMENT ON TABLE tsk_p105_checklist_v IS '';

