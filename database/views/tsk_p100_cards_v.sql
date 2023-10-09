CREATE OR REPLACE FORCE VIEW tsk_p100_cards_v AS
WITH t AS (
    SELECT /*+ MATERIALIZE */
       t.*
       --
       -- @TODO: limit columns
       --
    FROM tsk_cards t
    JOIN tsk_auth_context_v x
        ON x.client_id      = t.client_id
        AND x.project_id    = t.project_id
        AND x.board_id      = t.board_id
        --
        AND (x.swimlane_id  = t.swimlane_id OR x.swimlane_id IS NULL)
        AND (x.owner_id     = t.owner_id    OR x.owner_id IS NULL)
),
p AS (
    -- to calculate cards progress
    SELECT /*+ MATERIALIZE */
        p.card_id,
        NULLIF(SUM(CASE WHEN p.checklist_done = 'Y' THEN 1 ELSE 0 END) || '/' || COUNT(p.checklist_id), '0/0') AS card_progress
    FROM tsk_card_checklist p
    JOIN t
        ON t.card_id        = p.card_id
    GROUP BY p.card_id
)
SELECT
    t.card_id,
    t.card_name,
    t.card_number,
    --
    APEX_PAGE.GET_URL (
        p_page          => 105,
        p_clear_cache   => 105,
        p_items         => 'P105_CARD_ID,P105_SOURCE_PAGE',
        p_values        => '' || t.card_id || ',100'
    ) AS card_link,
    --
    p.card_progress,
    --
    t.client_id,
    t.project_id,
    t.board_id,
    --
    t.status_id,
    t.swimlane_id,
    t.category_id,
    t.owner_id,
    t.deadline_at,
    --
    LTRIM(RTRIM(REPLACE(t.tags, ':', ' '))) AS tags,
    --
    g.color_bg,
    t.created_by,
    t.created_at,
    t.updated_by,
    t.updated_at,
    --
    LAG(t.card_id) OVER (
        PARTITION BY t.client_id, t.project_id, t.board_id
        ORDER BY w.order# NULLS LAST, s.order# NULLS LAST, t.order# NULLS LAST
    ) AS prev_card,
    --
    LEAD(t.card_id) OVER (
        PARTITION BY t.client_id, t.project_id, t.board_id
        ORDER BY w.order# NULLS LAST, s.order# NULLS LAST, t.order# NULLS LAST
    ) AS next_card,
    --
    w.order#            AS swimlane_order#,
    s.order#            AS status_order#,
    t.order#            AS card_order#,
    --
    ROW_NUMBER() OVER (ORDER BY t.order# NULLS LAST, t.card_id) AS order#
    --
FROM t
JOIN tsk_lov_statuses_v s
    ON s.status_id      = t.status_id
JOIN tsk_lov_swimlanes_v w
    ON w.swimlane_id    = t.swimlane_id
LEFT JOIN tsk_lov_categories_v g
    ON g.category_id    = t.category_id
    AND g.color_bg      IS NOT NULL
LEFT JOIN p
    ON p.card_id        = t.card_id;
--
COMMENT ON TABLE tsk_p100_cards_v IS '';

