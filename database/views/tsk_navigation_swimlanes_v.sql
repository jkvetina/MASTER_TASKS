CREATE OR REPLACE FORCE VIEW tsk_navigation_swimlanes_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()   AS app_id,
        core.get_user_id()  AS user_id,
        --
        n.order#            AS endpoint,
        --
        core.get_item('P0_SWIMLANE_ID') AS swimlane_id
        --
    FROM app_navigation_v n
    WHERE n.app_id          = core.get_app_id()
        AND n.page_id       = 310  -- swimlanes
),
counts AS (
    SELECT /*+ MATERIALIZE */
        c.swimlane_id,
        COUNT(*)            AS row_count
    FROM tsk_p100_cards_v c
    GROUP BY
        c.swimlane_id
),
filter_data AS (
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => 'All Swimlanes',
            in_page_id      => core.get_page_id(),
            in_swimlane_id  => '-',
            in_class        => '',
            in_icon_name    => ''
        ) AS attribute01,
        --
        ' class="NAV_L3"' AS attribute10,
        --
        x.endpoint || '/0/.' AS order#
        --
    FROM x
    UNION ALL
    --
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => a.swimlane_name,
            in_page_id      => core.get_page_id(),
            in_swimlane_id  => a.swimlane_id,
            in_class        => '',
            in_icon_name    => CASE WHEN x.swimlane_id = a.swimlane_id THEN 'fa-arrow-circle-right' END,
            in_badge        => c.row_count
        ) AS attribute01,
        --
        ' class="NAV_L3' || CASE WHEN x.swimlane_id = a.swimlane_id THEN ' ACTIVE' END || '"' AS attribute10,
        --
        x.endpoint || '/0/' || a.order# AS order#
        --
    FROM tsk_lov_swimlanes_v a
    CROSS JOIN x
    LEFT JOIN counts c
        ON c.swimlane_id    = a.swimlane_id
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-chevron-down') || ' &nbsp; Select Swimlane</span>' AS attribute01,
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
COMMENT ON TABLE tsk_navigation_swimlanes_v IS '';

