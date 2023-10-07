CREATE OR REPLACE FORCE VIEW tsk_boards_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_board_id()      AS board_id,
        core.get_user_id()          AS user_id
    FROM DUAL
),
s AS (
    SELECT /*+ MATERIALIZE */
        t.client_id,
        t.project_id,
        t.board_id,
        s.status_id,
        s.status_name,
        s.is_active,
        --
        ROW_NUMBER() OVER (PARTITION BY s.is_active ORDER BY s.order# NULLS LAST, s.status_id) AS r#,
        --
        COUNT(t.card_id)    AS count_cards
        --
    FROM tsk_cards t
    JOIN tsk_available_projects_v a
        ON a.client_id      = t.client_id
        AND a.project_id    = t.project_id
    JOIN x
        ON x.client_id      = a.client_id
        AND x.project_id    = a.project_id
    JOIN tsk_statuses s
        ON s.client_id      = t.client_id
        AND s.project_id    = t.project_id
        AND s.status_id     = t.status_id
    GROUP BY
        t.client_id,
        t.project_id,
        t.board_id,
        s.status_id,
        s.status_name,
        s.is_active,
        s.order#
),
g AS (
    SELECT /*+ MATERIALIZE */
        s.client_id,
        s.project_id,
        s.board_id,
        --
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 1 THEN s.count_cards END) AS count_status_1,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 2 THEN s.count_cards END) AS count_status_2,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 3 THEN s.count_cards END) AS count_status_3,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 4 THEN s.count_cards END) AS count_status_4,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 5 THEN s.count_cards END) AS count_status_5,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 6 THEN s.count_cards END) AS count_status_6,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 7 THEN s.count_cards END) AS count_status_7,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 8 THEN s.count_cards END) AS count_status_8,
        --
        SUM(CASE WHEN s.is_active IS NULL THEN s.count_cards END) AS count_inactive,
        SUM(s.count_cards) AS count_total,
        --
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 1 THEN s.status_name END) AS status_name_1,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 2 THEN s.status_name END) AS status_name_2,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 3 THEN s.status_name END) AS status_name_3,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 4 THEN s.status_name END) AS status_name_4,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 5 THEN s.status_name END) AS status_name_5,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 6 THEN s.status_name END) AS status_name_6,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 7 THEN s.status_name END) AS status_name_7,
        MAX(CASE WHEN s.is_active = 'Y' AND s.r# = 8 THEN s.status_name END) AS status_name_8
        --
    FROM s
    GROUP BY
        s.client_id,
        s.project_id,
        s.board_id
)
SELECT
    t.board_id      AS old_board_id,
    --
    t.client_id,
    t.project_id,
    t.board_id,
    t.board_name,
    --
    CASE WHEN f.board_id IS NOT NULL THEN 'Y' END AS is_favorite,
    --
    t.is_active,
    t.is_default,
    t.order#,
    --
    g.count_status_1,
    g.count_status_2,
    g.count_status_3,
    g.count_status_4,
    g.count_status_5,
    g.count_status_6,
    g.count_status_7,
    g.count_status_8,
    g.count_inactive,
    g.count_total,
    --
    MAX(g.status_name_1) OVER() AS status_name_1,
    MAX(g.status_name_2) OVER() AS status_name_2,
    MAX(g.status_name_3) OVER() AS status_name_3,
    MAX(g.status_name_4) OVER() AS status_name_4,
    MAX(g.status_name_5) OVER() AS status_name_5,
    MAX(g.status_name_6) OVER() AS status_name_6,
    MAX(g.status_name_7) OVER() AS status_name_7,
    MAX(g.status_name_8) OVER() AS status_name_8
    --
FROM tsk_available_boards_v t
JOIN x
    ON x.client_id      = t.client_id
    AND x.project_id    = t.project_id
LEFT JOIN g
    ON g.client_id      = t.client_id
    AND g.project_id    = t.project_id
    AND g.board_id      = t.board_id
LEFT JOIN tsk_boards_fav f
    ON f.user_id        = x.user_id
    AND f.client_id     = t.client_id
    AND f.project_id    = t.project_id
    AND f.board_id      = t.board_id;
--
COMMENT ON TABLE tsk_boards_v IS '';

