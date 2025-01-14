CREATE OR REPLACE FORCE VIEW tsk_p110_cards_v AS
WITH x AS (
    SELECT
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        --
        core.get_number_item('$SOURCE_BOARD')   AS board_id,
        core.get_item('$SOURCE_MILESTONE')      AS milestone_id,
        core.get_item('$SOURCE_STATUS')         AS status_id,
        core.get_item('$SOURCE_CATEGORY')       AS category_id,
        core.get_item('$SOURCE_OWNER')          AS owner_id
    FROM DUAL
)
SELECT
    t.card_id,
    t.card_number,
    NVL(t.card_number, '#' || t.card_id) AS card_id__,
    t.card_name,
    t.status_id,
    t.milestone_id,
    t.category_id,
    t.owner_id,
    t.deadline_at,
    --
    APEX_PAGE.GET_URL (
        p_page          => 105,
        p_clear_cache   => 105,
        p_items         => 'P105_CARD_ID,P105_SOURCE_PAGE',
        p_values        => '' || t.card_id || ',110'
    ) AS card_link,
    --
    'N' AS selected_row     -- Y/N, changed by JS
    --
FROM tsk_cards t
CROSS JOIN x
JOIN tsk_available_boards_v b
    ON b.client_id      = x.client_id
    AND b.project_id    = x.project_id
    AND b.board_id      = x.board_id
WHERE 1 = 1
    AND x.client_id     = t.client_id
    AND x.project_id    = t.project_id
    AND x.board_id      = t.board_id
    --
    AND (x.owner_id     = t.owner_id        OR x.owner_id IS NULL)
    AND (x.milestone_id = t.milestone_id    OR x.milestone_id IS NULL)
    AND (x.status_id    = t.status_id       OR x.status_id IS NULL)
    AND (x.category_id  = t.category_id     OR x.category_id IS NULL);
/

