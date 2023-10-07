CREATE OR REPLACE FORCE VIEW tsk_clients_v AS
WITH c AS (
    SELECT /*+ MATERIALIZE */
        t.client_id,
        --
        COUNT(DISTINCT t.project_id)    AS count_projects,
        COUNT(DISTINCT t.board_id)      AS count_boards,
        COUNT(*)                        AS count_cards
        --
    FROM tsk_cards t
    JOIN tsk_available_clients_v a
        ON a.client_id  = t.client_id
    GROUP BY
        t.client_id
)
SELECT
    t.client_id         AS old_client_id,       -- to allow PK changes
    --
    t.client_id,
    t.client_name,
    t.is_active,
    --
    c.count_projects,
    c.count_boards,
    c.count_cards
    --
FROM tsk_available_clients_v t
LEFT JOIN c
    ON c.client_id      = t.client_id;
--
COMMENT ON TABLE tsk_clients_v IS '';

