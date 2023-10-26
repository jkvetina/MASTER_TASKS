CREATE OR REPLACE FORCE VIEW tsk_navigation_owners_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()               AS app_id,
        core.get_user_id()              AS user_id,
        core.get_item('P0_OWNER_ID')    AS owner_id
    FROM DUAL
),
endpoints AS (
    SELECT /*+ MATERIALIZE */
        x.owner_id,
        --
        MAX(CASE WHEN n.page_id = 360 THEN n.order# END) AS owners
        --
    FROM app_navigation_v n
    JOIN x
        ON x.app_id     = n.app_id
    GROUP BY
        x.owner_id
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
        e.owners || '.' AS order#
        --
    FROM endpoints e
    UNION ALL
    SELECT
        2 AS lvl,
        --
        tsk_nav.get_link (
            in_content      => a.owner_name,
            in_page_id      => core.get_page_id(),
            in_owner_id     => a.owner_id,
            in_class        => '',
            in_icon_name    => CASE WHEN a.is_current = 'Y' THEN 'fa-arrow-circle-right' END
        ) AS attribute01,
        --
        ' class="NAV_L3' || CASE WHEN a.is_current = 'Y' THEN ' ACTIVE' END || '"' AS attribute10,
        --
        e.owners || '.' || a.order# AS order#
        --
    FROM (
        SELECT DISTINCT
            t.owner_id,
            t.owner_id AS owner_name,
            CASE WHEN t.owner_id = tsk_app.get_owner_id() THEN 'Y' END AS is_current,
            t.owner_id AS order#
            --
        FROM tsk_p100_cards_v t
        WHERE t.owner_id IS NOT NULL
    ) a
    CROSS JOIN endpoints e
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
    e.owners || '/0/' AS order#
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
    '' AS attribute08,
    '' AS attribute09,
    --
    t.attribute10,
    --
    e.owners || '/0/' || t.order# AS order#
    --
FROM filter_data t
JOIN endpoints e
    ON e.owners IS NOT NULL;
--
COMMENT ON TABLE tsk_navigation_owners_v IS '';

