CREATE OR REPLACE FORCE VIEW tsk_navigation_owners_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()   AS app_id,
        core.get_user_id()  AS user_id,
        --
        n.order#            AS endpoint,
        --
        core.get_item('P0_OWNER_ID')    AS owner_id
        --
    FROM app_navigation_v n
    WHERE n.app_id          = core.get_app_id()
        AND n.page_id       = 360  -- owners
),
counts AS (
    SELECT /*+ MATERIALIZE */
        c.owner_id,
        COUNT(*)            AS row_count
    FROM tsk_p100_cards_v c
    GROUP BY
        c.owner_id
),
a AS (
    SELECT DISTINCT /*+ MATERIALIZE */
        t.owner_id,
        NVL(u.user_name, t.owner_id) AS owner_name,
        --
        CASE WHEN t.owner_id = tsk_app.get_owner_id() THEN 'Y' END AS is_current,
        t.owner_id AS order#
        --
    FROM tsk_p100_cards_v t
    LEFT JOIN tsk_lov_users_v u
        ON u.user_id    = t.owner_id
    WHERE t.owner_id    IS NOT NULL
),
filter_data AS (
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => 'All Owners',
            in_page_id      => core.get_page_id(),
            in_owner_id     => '-',
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
            in_content      => 'No Owner',
            in_page_id      => core.get_page_id(),
            in_owner_id     => '!',
            in_class        => '',
            in_icon_name    => CASE WHEN x.owner_id = '!' THEN 'fa-arrow-circle-right' END,
            in_badge        => c.row_count
        ) AS attribute01,
        --
        ' class="NAV_L3' || CASE WHEN x.owner_id = '!' THEN ' ACTIVE' END || '"' AS attribute10,
        --
        x.endpoint || '/0/..' AS order#
        --
    FROM x
    LEFT JOIN counts c
        ON 1 = 1
        AND c.owner_id      IS NULL
    UNION ALL
    --
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => a.owner_name,
            in_page_id      => core.get_page_id(),
            in_owner_id     => a.owner_id,
            in_class        => '',
            in_icon_name    => CASE WHEN a.is_current = 'Y' THEN 'fa-arrow-circle-right' END,
            in_badge        => c.row_count
        ) AS attribute01,
        --
        ' class="NAV_L3' || CASE WHEN a.is_current = 'Y' THEN ' ACTIVE' END || '"' AS attribute10,
        --
        x.endpoint || '/0/' || a.order# AS order#
        --
    FROM a
    CROSS JOIN x
    LEFT JOIN counts c
        ON c.owner_id       = a.owner_id
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-chevron-down') || ' &nbsp; Select Owner</span>' AS attribute01,
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
COMMENT ON TABLE tsk_navigation_owners_v IS '';

