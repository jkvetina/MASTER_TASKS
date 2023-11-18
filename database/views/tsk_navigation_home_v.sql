CREATE OR REPLACE FORCE VIEW tsk_navigation_home_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()   AS app_id,
        core.get_user_id()  AS user_id,
        --
        n.order#            AS endpoint
        --
    FROM app_navigation_v n
    WHERE n.app_id          = core.get_app_id()
        AND n.page_id       = 100  -- home
),
filter_data AS (
    SELECT /*+ MATERIALIZE */
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => b.client_name,
            in_page_id      => 100,
            in_client_id    => b.client_id,
            in_class        => '',
            in_icon_name    => CASE WHEN b.is_current_client = 'Y' THEN 'fa-arrow-circle-right' END
        ) AS attribute01,
        --
        ' class="NAV_L2"' AS attribute10,
        --
        x.endpoint || '/0/' || b.client_id AS order#
        --
    FROM tsk_available_boards_v b
    CROSS JOIN x
    WHERE b.is_favorite = 'Y'
    GROUP BY
        x.endpoint,
        b.client_id,
        b.client_name,
        b.is_current_client
    UNION ALL
    --
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => b.project_name,
            in_page_id      => 100,
            in_client_id    => b.client_id,
            in_project_id   => b.project_id,
            in_class        => '',
            in_icon_name    => CASE WHEN b.is_current_project = 'Y' THEN 'fa-arrow-circle-right' END
        ) AS attribute01,
        --
        ' class="NAV_L3' || CASE WHEN b.is_current_project = 'Y' AND MIN(b.board_id) = MAX(b.board_id) THEN ' ACTIVE' END || '"' AS attribute10,
        --
        x.endpoint || '/0/' || b.client_id || '/' || b.project_id AS order#
        --
    FROM tsk_available_boards_v b
    CROSS JOIN x
    WHERE b.is_favorite = 'Y'
    GROUP BY
        x.endpoint,
        b.client_id,
        b.project_id,
        b.project_name,
        b.is_current_project
    UNION ALL
    --
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => b.board_name,
            in_page_id      => 100,
            in_client_id    => b.client_id,
            in_project_id   => b.project_id,
            in_board_id     => b.board_id,
            in_swimlane_id  => b.fav_swimlane_id,
            in_status_id    => '',
            in_owner_id     => b.fav_owner_id,
            in_class        => '',
            in_icon_name    => CASE WHEN b.is_current = 'Y' THEN 'fa-arrow-circle-right' END
        ) AS attribute01,
        --
        ' class="NAV_L4' || CASE WHEN b.is_current = 'Y' THEN ' ACTIVE' END || '"' AS attribute10,
        --
        x.endpoint || '/0/' || b.client_id || '/' || b.project_id || '/' || b.order# AS order#
        --
    FROM tsk_available_boards_v b
    CROSS JOIN x
    JOIN (
        SELECT
            b.client_id,
            b.project_id,
            COUNT(b.board_id) AS boards
            --
        FROM tsk_available_boards_v b
        WHERE b.is_favorite = 'Y'
        GROUP BY
            b.client_id,
            b.project_id
    ) c
        ON c.client_id      = b.client_id
        AND c.project_id    = b.project_id
        AND c.boards        > 1
    WHERE b.is_favorite     = 'Y'
    GROUP BY
        x.endpoint,
        b.client_id,
        b.project_id,
        b.project_name,
        b.board_id,
        b.board_name,
        b.fav_swimlane_id,
        b.fav_owner_id,
        b.is_current,
        b.order#
),
recent_cards AS (
    SELECT /*+ MATERIALIZE */
        CASE WHEN core.get_page_id() = 100
            THEN tsk_nav.get_link (
                in_content      => t.card_name,
                in_page_id      => 105,
                in_items        => 'P105_CARD_ID',
                in_values       => t.card_id
            )
            ELSE tsk_nav.get_link (
                in_content      => t.card_name,
                in_page_id      => 100,
                in_client_id    => t.client_id,
                in_project_id   => t.project_id,
                in_board_id     => t.board_id,
                in_items        => 'P100_CARD_ID',
                in_values       => t.card_id
            )
            END AS attribute01,
        --
        ROW_NUMBER() OVER (ORDER BY t.updated_at DESC) AS order#
        --
    FROM tsk_cards t
    JOIN tsk_available_boards_v b
        ON b.client_id      = t.client_id
        AND b.project_id    = t.project_id
        AND b.board_id      = t.board_id
        AND b.is_current    = 'Y'
    ORDER BY t.updated_at DESC
    FETCH FIRST 5 ROW ONLY
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-bookmark') || ' &nbsp; Favorite Boards</span>' AS attribute01,
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
FROM filter_data t
UNION ALL
--
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-alarm-clock') || ' &nbsp; Recent Cards</span>' AS attribute01,
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
    x.endpoint || '/1/' AS order#
    --
FROM x
UNION ALL
--
SELECT
    2 AS lvl,
    --
    t.attribute01,
    --
    '' AS attribute02,
    '' AS attribute03,
    '' AS attribute04,
    '' AS attribute05,
    '' AS attribute06,
    '' AS attribute07,
    --
    ''                  AS attribute08,
    ''                  AS attribute09,
    ' class="NAV_L3"'   AS attribute10,
    --
    x.endpoint || '/1/' || t.order# AS order#
    --
FROM recent_cards t
CROSS JOIN x;
--
COMMENT ON TABLE tsk_navigation_home_v IS '';

