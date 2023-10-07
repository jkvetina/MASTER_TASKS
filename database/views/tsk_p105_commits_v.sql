CREATE OR REPLACE FORCE VIEW tsk_p105_commits_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        t.card_id
    FROM tsk_p100_cards_v t
    WHERE t.card_id = core.get_item('P105_CARD_ID')
)
SELECT
    t.commit_id,
    t.commit_message,
    t.commit_url,
    t.created_by,
    t.created_at,
    --
    t.created_at || ' ' || t.created_by AS created,
    --
    t.commit_message || '<br />' || t.created_by || ' ' || t.created_at || ' ' ||
    '<a href="' || t.commit_url || '" target="_blank">' || t.commit_id || '</a>' AS payload
    --
FROM tsk_p500_commits_v t
JOIN x
    ON x.card_id        = t.card_id;
--
COMMENT ON TABLE tsk_p105_commits_v IS '';

