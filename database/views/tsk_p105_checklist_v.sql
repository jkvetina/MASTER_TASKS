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
    t.checklist_item,
    t.checklist_level,
    --
    COALESCE(t.order#, LPAD(ROW_NUMBER() OVER (ORDER BY t.order# NULLS LAST, t.checklist_id), 3, '0')) AS old_order,
    --
    TO_CHAR(ROW_NUMBER() OVER (ORDER BY t.order# NULLS LAST, t.checklist_id) - 1) AS new_order,  -- populated by JS
    --
    'LEVEL' || NULLIF(t.checklist_level, 0) AS css_class
    --
FROM tsk_card_checklist t
JOIN x
    ON x.card_id    = t.card_id
UNION ALL
--
SELECT
    NULL        AS card_id,
    -1          AS checklist_id,        -- create new/empty row
    NULL        AS checklist_done,
    NULL        AS checklist_item,
    NULL        AS checklist_level,
    NULL        AS old_order,
    NULL        AS new_order,
    NULL        AS css_class
FROM DUAL;
--
COMMENT ON TABLE tsk_p105_checklist_v IS '';

