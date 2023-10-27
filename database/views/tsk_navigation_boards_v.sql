CREATE OR REPLACE FORCE VIEW tsk_navigation_boards_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()   AS app_id,
        core.get_user_id()  AS user_id,
        --
        n.order#            AS endpoint
        --
    FROM app_navigation_v n
    WHERE n.app_id          = core.get_app_id()
        AND n.page_id       = 400  -- boards
),
counts AS (
    SELECT /*+ MATERIALIZE */
        c.board_id,
        COUNT(*)        AS row_count
    FROM tsk_cards c
    JOIN tsk_available_boards_v a
        ON a.board_id = c.board_id
    GROUP BY
        c.board_id
),
filter_data AS (
    SELECT
        2 AS lvl,
        a.is_current,
        --
        tsk_nav.get_link (
            in_content      => a.board_name,
            in_page_id      => core.get_page_id(),
            in_client_id    => a.client_id,
            in_project_id   => a.project_id,
            in_board_id     => a.board_id,
            in_class        => '',
            in_icon_name    => CASE WHEN a.is_current = 'Y' THEN 'fa-arrow-circle-right' END,
            in_badge        => c.row_count
        ) AS attribute01,
        --
        ' class="NAV_L3' || REPLACE(a.is_current, 'Y', ' ACTIVE') || '"' AS attribute10,
        --
        x.endpoint || '/0/' || a.board_id AS order#
        --
    FROM tsk_available_boards_v a
    CROSS JOIN x
    LEFT JOIN counts c
        ON c.board_id           = a.board_id
    WHERE a.is_current_project  = 'Y'
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-chevron-down') || ' &nbsp; Select Board</span>' AS attribute01,
    --
    '' AS attribute02,
    '' AS attribute03,
    '' AS attribute04,
    '' AS attribute05,
    '' AS attribute06,
    '' AS attribute07,
    --
    '</ul><ul>'         AS attribute08,
    ''                  AS attribute09,
    ' class="NAV_L2"'   AS attribute10,
    --
    x.endpoint || '/0/' AS order#
    --
FROM x
UNION ALL
--
SELECT
    t.lvl,
    t.attribute01,
    --
    '' AS attribute02,
    '' AS attribute03,
    '' AS attribute04,
    '' AS attribute05,
    '' AS attribute06,
    '' AS attribute07,
    '' AS attribute08,
    '' AS attribute09,
    --
    t.attribute10,
    t.order#
    --
FROM filter_data t;
--
COMMENT ON TABLE tsk_navigation_boards_v IS '';

