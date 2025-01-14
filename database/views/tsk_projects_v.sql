CREATE OR REPLACE FORCE VIEW tsk_projects_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        t.client_id
    FROM tsk_available_clients_v t
),
t AS (
    SELECT /*+ MATERIALIZE */
        t.client_id,
        t.project_id,
        --
        COUNT(DISTINCT t.board_id)      AS count_boards,
        COUNT(DISTINCT t.milestone_id)  AS count_milestones,
        COUNT(DISTINCT t.status_id)     AS count_statuses,
        COUNT(DISTINCT t.category_id)   AS count_categories,
        COUNT(DISTINCT t.owner_id)      AS count_owners,
        COUNT(*)                        AS count_cards
        --
    FROM tsk_cards t
    JOIN x
        ON x.client_id      = t.client_id
    GROUP BY
        t.client_id,
        t.project_id
)
--
SELECT
    a.client_id,
    a.project_id,
    a.project_name,
    a.is_active,
    a.is_default,
    --
    CASE WHEN a.is_current = 'Y' THEN core.get_icon('fa-arrow-circle-right') END AS is_current,
    --
    t.count_boards,
    t.count_milestones,
    t.count_statuses,
    t.count_categories,
    t.count_owners,
    t.count_cards
    --
    -- @TODO: add users/admins?
    --
FROM tsk_available_projects_v a
JOIN x
    ON x.client_id      = a.client_id
LEFT JOIN t
    ON t.client_id      = a.client_id
    AND t.project_id    = a.project_id;
/

