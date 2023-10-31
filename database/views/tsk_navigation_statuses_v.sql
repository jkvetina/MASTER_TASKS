CREATE OR REPLACE FORCE VIEW tsk_navigation_statuses_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()   AS app_id,
        core.get_user_id()  AS user_id,
        --
        n.order#            AS endpoint,
        --
        core.get_item('P0_STATUS_ID')   AS status_id
        --
    FROM app_navigation_v n
    WHERE n.app_id          = core.get_app_id()
        AND n.page_id       = 320  -- statuses
),
counts AS (
    SELECT /*+ MATERIALIZE */
        c.status_id,
        COUNT(*)        AS row_count
    FROM tsk_p100_cards_v c
    GROUP BY
        c.status_id
),
a AS (
    SELECT /*+ MATERIALIZE */
        t.status_group
    FROM tsk_lov_statuses_v t
    WHERE t.status_group IS NOT NULL
    GROUP BY
        t.status_group
),
filter_data AS (
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => 'All Statuses',
            in_page_id      => core.get_page_id(),
            in_status_id  => '-',
            in_class        => '',
            in_icon_name    => ''
        ) AS attribute01,
        --
        '' AS attribute08,
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
            in_content      => 'No status',
            in_page_id      => core.get_page_id(),
            in_status_id  => '!',
            in_class        => '',
            in_icon_name    => CASE WHEN x.status_id = '!' THEN 'fa-arrow-circle-right' END,
            in_badge        => c.row_count
        ) AS attribute01,
        --
        '' AS attribute08,
        ' class="NAV_L3' || CASE WHEN x.status_id = '!' THEN ' ACTIVE' END || '"' AS attribute10,
        --
        x.endpoint || '/0/..' AS order#
        --
    FROM x
    LEFT JOIN counts c
        ON 1 = 1
        AND c.status_id   IS NULL
    UNION ALL
    --
    SELECT
        2 AS lvl,
        --
        '<span>' || a.status_group || '</span>' AS attribute01,
        --
        '</ul><ul>'         AS attribute08,     -- start new column with each group
        ' class="NAV_L2"'   AS attribute10,
        --
        x.endpoint || '/0/' || a.status_group AS order#
        --
    FROM a
    CROSS JOIN x
    --
    UNION ALL
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => a.status_name,
            in_page_id      => core.get_page_id(),
            in_status_id  => a.status_id,
            in_class        => '',
            in_icon_name    => CASE WHEN x.status_id = a.status_id THEN 'fa-arrow-circle-right' END,
            in_badge        => c.row_count
        ) AS attribute01,
        --
        '' AS attribute08,
        ' class="NAV_L3' || CASE WHEN x.status_id = a.status_id THEN ' ACTIVE' END || '"' AS attribute10,
        --
        x.endpoint || '/0/' || a.status_group || '.' || a.order# AS order#
        --
    FROM tsk_lov_statuses_v a
    CROSS JOIN x
    LEFT JOIN counts c
        ON c.status_id    = a.status_id
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-chevron-down') || ' &nbsp; Select Status</span>' AS attribute01,
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
    t.attribute08,
    '' AS attribute09,
    t.attribute10,
    t.order# AS order#
    --
FROM filter_data t;
--
COMMENT ON TABLE tsk_navigation_statuses_v IS '';

