CREATE OR REPLACE FORCE VIEW tsk_projects_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()     AS client_id
    FROM DUAL
),
b AS (
    SELECT /*+ MATERIALIZE */
        t.project_id,
        --
        COUNT(DISTINCT t.board_id)  AS count_boards,
        COUNT(*)                    AS count_tasks
        --
    FROM tsk_tasks t
    JOIN tsk_available_projects_v a
        ON a.client_id      = t.client_id
        AND a.project_id    = t.project_id
    JOIN x
        ON x.client_id      = a.client_id
    GROUP BY
        t.project_id
),
s AS (
    SELECT /*+ MATERIALIZE */
        t.project_id,
        --
        COUNT(*)        AS count_statuses
    FROM tsk_statuses t
    JOIN x
        ON x.client_id  = t.client_id
    GROUP BY
        t.project_id
),
w AS (
    SELECT /*+ MATERIALIZE */
        t.project_id,
        --
        COUNT(*)        AS count_swimlanes
    FROM tsk_swimlanes t
    JOIN x
        ON x.client_id  = t.client_id
    GROUP BY
        t.project_id
),
c AS (
    SELECT /*+ MATERIALIZE */
        t.project_id,
        --
        COUNT(*)        AS count_categories
    FROM tsk_categories t
    JOIN x
        ON x.client_id  = t.client_id
    GROUP BY
        t.project_id
),
u AS (
    SELECT /*+ MATERIALIZE */
        p.project_id,
        --
        COUNT(DISTINCT a.user_id) AS count_users
    FROM tsk_projects p
    JOIN x
        ON x.client_id      = p.client_id
    JOIN tsk_available_projects_v a
        ON a.client_id      = p.client_id
        AND (a.project_id   = p.project_id OR a.project_id IS NULL)
    GROUP BY
        p.project_id
)
--
SELECT
    t.project_id        AS old_project_id,      -- to allow PK changes
    t.client_id         AS old_client_id,       -- to allow PK changes
    --
    t.client_id,
    t.project_id,
    t.project_name,
    --
    c.count_categories,
    s.count_statuses,
    w.count_swimlanes,
    b.count_boards,
    b.count_tasks,
    u.count_users
    --
FROM tsk_available_projects_v t
JOIN x
    ON x.client_id          = t.client_id
    --
LEFT JOIN b ON b.project_id = t.project_id
LEFT JOIN s ON s.project_id = t.project_id
LEFT JOIN w ON w.project_id = t.project_id
LEFT JOIN c ON c.project_id = t.project_id
LEFT JOIN u ON u.project_id = t.project_id;
--
COMMENT ON TABLE tsk_projects_v IS '';
