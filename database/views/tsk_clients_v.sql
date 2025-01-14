CREATE OR REPLACE FORCE VIEW tsk_clients_v AS
WITH t AS (
    SELECT /*+ MATERIALIZE */
        t.client_id,
        --
        COUNT(DISTINCT t.project_id)    AS count_projects,
        COUNT(DISTINCT t.board_id)      AS count_boards,
        COUNT(DISTINCT t.milestone_id)  AS count_milestones,
        COUNT(DISTINCT t.status_id)     AS count_statuses,
        COUNT(DISTINCT t.category_id)   AS count_categories,
        COUNT(DISTINCT t.owner_id)      AS count_owners,
        COUNT(*)                        AS count_cards
        --
    FROM tsk_cards t
    GROUP BY
        t.client_id
)
--
SELECT
    a.client_id,
    a.client_name,
    a.is_active,
    --
    CASE WHEN a.is_current = 'Y' THEN core.get_icon('fa-arrow-circle-right') END AS is_current,
    --
    t.count_projects,
    t.count_boards,
    t.count_milestones,
    t.count_statuses,
    t.count_categories,
    t.count_owners,
    t.count_cards
    --
    -- @TODO: add users/admins?
    --
FROM tsk_available_clients_v a
LEFT JOIN t
    ON t.client_id      = a.client_id;
/

