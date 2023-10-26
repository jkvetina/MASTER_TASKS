CREATE OR REPLACE FORCE VIEW tsk_navigation_categories_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()               AS app_id,
        core.get_user_id()              AS user_id,
        core.get_item('P0_CATEGORY_ID') AS category_id
    FROM DUAL
),
endpoints AS (
    SELECT /*+ MATERIALIZE */
        x.category_id,
        --
        MAX(CASE WHEN n.page_id = 340 THEN n.order# END) AS categories
        --
    FROM app_navigation_v n
    JOIN x
        ON x.app_id     = n.app_id
    GROUP BY
        x.category_id
),
filter_data AS (
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => 'All Categories',
            in_page_id      => core.get_page_id(),
            in_category_id  => '-',
            in_class        => '',
            in_icon_name    => ''
        ) AS attribute01,
        --
        '' AS attribute08,
        ' class="NAV_L3"' AS attribute10,
        --
        e.categories || '.' AS order#
        --
    FROM endpoints e
    UNION ALL
    --
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => 'No Category',
            in_page_id      => core.get_page_id(),
            in_category_id  => '!',
            in_class        => '',
            in_icon_name    => ''
        ) AS attribute01,
        --
        '' AS attribute08,
        ' class="NAV_L3"' AS attribute10,
        --
        e.categories || '..' AS order#
        --
    FROM endpoints e
    UNION ALL
    --
    SELECT
        2 AS lvl,
        --
        '<span>' || a.category_group || '</span>' AS attribute01,
        --
        '</ul><ul>'         AS attribute08,     -- start new column with each group
        ' class="NAV_L2"'   AS attribute10,
        --
        e.categories || '.' || a.category_group AS order#
        --
    FROM (
        SELECT DISTINCT
            t.category_group
        FROM tsk_lov_categories_v t
        CROSS JOIN endpoints e
        WHERE t.category_group IS NOT NULL
    ) a
    CROSS JOIN endpoints e
    --
    UNION ALL
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => a.category_name,
            in_page_id      => core.get_page_id(),
            in_category_id  => a.category_id,
            in_class        => '',
            in_icon_name    => CASE WHEN e.category_id = a.category_id THEN 'fa-arrow-circle-right' END,
            in_badge        => c.row_count
        ) AS attribute01,
        --
        '' AS attribute08,
        ' class="NAV_L3' || CASE WHEN e.category_id = a.category_id THEN ' ACTIVE' END || '"' AS attribute10,
        --
        e.categories || '.' || a.category_group || '.' || a.order# AS order#
        --
    FROM tsk_lov_categories_v a
    CROSS JOIN endpoints e
    LEFT JOIN (
        SELECT
            c.category_id,
            COUNT(*)        AS row_count
        FROM tsk_p100_cards_v c
        GROUP BY c.category_id
    ) c
        ON c.category_id = a.category_id
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-chevron-down') || ' &nbsp; Select Category</span>' AS attribute01,
    --
    '' AS attribute02,
    '' AS attribute03,
    '' AS attribute04,
    '' AS attribute05,
    '' AS attribute06,
    '' AS attribute07,
    '</ul><ul>' AS attribute08,
    '' AS attribute09,
    ' class="NAV_L2"' AS attribute10,
    --
    e.categories || '/0/' AS order#
    --
FROM endpoints e
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
    --
    e.categories || '/0/' || t.order# AS order#
    --
FROM filter_data t
JOIN endpoints e
    ON e.categories IS NOT NULL;
--
COMMENT ON TABLE tsk_navigation_categories_v IS '';

