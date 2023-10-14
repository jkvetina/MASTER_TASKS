CREATE OR REPLACE FORCE VIEW tsk_projects_v AS
WITH t AS (
    SELECT /*+ MATERIALIZE */
        t.client_id,
        t.project_id,
        --
        COUNT(DISTINCT t.board_id)      AS count_boards,
        COUNT(DISTINCT t.swimlane_id)   AS count_swimlanes,
        COUNT(DISTINCT t.status_id)     AS count_statuses,
        COUNT(DISTINCT t.category_id)   AS count_categories,
        COUNT(DISTINCT t.owner_id)      AS count_owners,
        COUNT(*)                        AS count_cards
        --
    FROM tsk_cards t
    JOIN tsk_available_projects_v p
        ON p.client_id      = t.client_id
        AND p.project_id    = t.project_id
    GROUP BY
        t.client_id,
        t.project_id
)
--
SELECT
    p.project_id        AS old_project_id,      -- to allow PK changes
    p.client_id         AS old_client_id,       -- to allow PK changes
    --
    p.client_id,
    p.project_id,
    p.project_name,
    p.is_active,
    p.is_default,
    p.is_current,
    --
    t.count_boards,
    t.count_swimlanes,
    t.count_statuses,
    t.count_categories,
    t.count_owners,
    t.count_cards
    --
    -- @TODO: add users/admins?
    --
FROM tsk_available_projects_v p
LEFT JOIN t
    ON t.client_id      = p.client_id
    AND t.project_id    = p.project_id;
--
COMMENT ON TABLE tsk_projects_v IS '';

