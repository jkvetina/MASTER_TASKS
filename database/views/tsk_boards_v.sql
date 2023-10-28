CREATE OR REPLACE FORCE VIEW tsk_boards_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        a.client_id,
        a.project_id
    FROM tsk_auth_context_v a
),
t AS (
    SELECT /*+ MATERIALIZE */
        t.client_id,
        t.project_id,
        t.board_id,
        --
        COUNT(DISTINCT t.board_id)      AS count_boards,
        COUNT(DISTINCT t.swimlane_id)   AS count_swimlanes,
        COUNT(DISTINCT t.status_id)     AS count_statuses,
        COUNT(DISTINCT t.category_id)   AS count_categories,
        COUNT(DISTINCT t.owner_id)      AS count_owners,
        COUNT(*)                        AS count_cards
        --
    FROM tsk_cards t
    JOIN x
        ON x.client_id      = t.client_id
        AND x.project_id    = t.project_id
    GROUP BY
        t.client_id,
        t.project_id,
        t.board_id
)
--
SELECT
    a.board_id          AS old_board_id,        -- to allow PK changes
    --
    a.client_id,
    a.client_name,
    a.project_id,
    a.project_name,
    a.board_id,
    a.board_name,
    a.sequence_id,
    a.is_simple,
    a.is_active,
    a.is_default,
    a.is_favorite,
    a.is_current,
    a.order#,
    --
    --t.count_boards,
    t.count_swimlanes,
    t.count_statuses,
    t.count_categories,
    t.count_owners,
    t.count_cards
    --
    -- @TODO: add users/admins?
    --
FROM tsk_available_boards_v a
JOIN x
    ON x.client_id      = a.client_id
    AND x.project_id    = a.project_id
LEFT JOIN t
    ON t.client_id      = a.client_id
    AND t.project_id    = a.project_id
    AND t.board_id      = a.board_id;
--
COMMENT ON TABLE tsk_boards_v IS '';

