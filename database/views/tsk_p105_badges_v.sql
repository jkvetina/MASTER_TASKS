CREATE OR REPLACE FORCE VIEW tsk_p105_badges_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        t.card_id
    FROM tsk_p100_cards_v t
    WHERE t.card_id = core.get_item('P105_CARD_ID')
)
SELECT
    'P105_BADGE_CHECKLIST'              AS item_name,
    CASE WHEN COUNT(*) > 0
        THEN '<span class="BADGE">' || COUNT(*) || '</span>'
        END AS badge
    --
FROM tsk_card_checklist c
JOIN x
    ON x.card_id            = c.card_id
WHERE c.checklist_done      IS NULL
--
UNION ALL
SELECT
    'P105_BADGE_COMMENTS'               AS item_name,
    CASE WHEN COUNT(*) > 0
        THEN '<span class="BADGE DECENT">' || COUNT(*) || '</span>'
        END AS badge
    --
FROM tsk_card_comments c
JOIN x
    ON x.card_id            = c.card_id
--
UNION ALL
SELECT
    'P105_BADGE_COMMITS'                AS item_name,
    CASE WHEN COUNT(*) > 0
        THEN '<span class="BADGE DECENT">' || COUNT(*) || '</span>'
        END AS badge
    --
FROM tsk_card_commits c
JOIN x
    ON x.card_id            = c.card_id
--
UNION ALL
SELECT
    'P105_BADGE_TAGS'                   AS item_name,
    CASE WHEN COUNT(*) > 0
        THEN '<span class="BADGE DECENT">' || COUNT(*) || '</span>'
        END AS badge
    --
FROM tsk_p105_tags_v c
--
UNION ALL
SELECT
    'P105_BADGE_FILES'                  AS item_name,
    CASE WHEN COUNT(*) > 0
        THEN '<span class="BADGE DECENT">' || COUNT(*) || '</span>'
        END AS badge
    --
FROM tsk_card_files c
JOIN x
    ON x.card_id            = c.card_id;
/

