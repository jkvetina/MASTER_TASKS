CREATE OR REPLACE FORCE VIEW tsk_clients_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()         AS curr_client_id
    FROM DUAL
),
c AS (
    SELECT /*+ MATERIALIZE */
        t.client_id,
        --
        COUNT(DISTINCT t.project_id)    AS count_projects,
        COUNT(DISTINCT t.board_id)      AS count_boards,
        COUNT(*)                        AS count_tasks
        --
    FROM tsk_tasks t
    GROUP BY
        t.client_id
)
SELECT
    t.client_id         AS old_client_id,       -- to allow PK changes
    --
    t.client_id,
    t.client_name,
    --
    CASE WHEN t.client_id = x.curr_client_id THEN 'Y' END AS is_current,
    --
    t.is_active,
    --
    c.count_projects,
    c.count_boards,
    c.count_tasks
    --
FROM tsk_clients t
JOIN tsk_available_clients_v a
    ON a.client_id      = t.client_id
CROSS JOIN x
LEFT JOIN c
    ON c.client_id      = t.client_id;
--
COMMENT ON TABLE tsk_clients_v IS '';

