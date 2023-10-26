CREATE OR REPLACE FORCE VIEW tsk_navigation_clients_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()           AS app_id,
        core.get_user_id()          AS user_id
    FROM DUAL
),
endpoints AS (
    SELECT /*+ MATERIALIZE */
        MAX(CASE WHEN n.page_id = 200 THEN n.order# END) AS clients,
        MAX(CASE WHEN n.page_id = 300 THEN n.order# END) AS projects,
        MAX(CASE WHEN n.page_id = 400 THEN n.order# END) AS boards
        --
    FROM app_navigation_v n
    JOIN x
        ON x.app_id     = n.app_id
),
filter_data AS (
    SELECT DISTINCT
        2 AS lvl,
        a.client_id,
        a.client_name,
        a.is_current,
        --
        tsk_nav.get_link (
            in_content      => a.client_name,
            in_page_id      => core.get_page_id(),
            in_client_id    => a.client_id,
            in_class        => '',
            in_icon_name    => CASE WHEN a.is_current = 'Y' THEN 'fa-arrow-circle-right' END
        ) AS attribute01,
        --
        ' class="NAV_L3' || REPLACE(a.is_current, 'Y', ' ACTIVE') || '"' AS attribute10,
        --
        '/0.200.' || a.client_id AS order#
        --
    FROM tsk_available_clients_v a
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-chevron-down') || ' &nbsp; Select Client</span>' AS attribute01,
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
    e.clients || '/0/' AS order#
    --
FROM endpoints e
WHERE e.clients IS NOT NULL
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
    e.clients || '/0/' || t.order# AS order#
    --
FROM filter_data t
JOIN endpoints e
    ON e.clients IS NOT NULL
UNION ALL
--
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-wrench') || ' &nbsp; Setup</span>' AS attribute01,
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
    e.clients || '/1/' AS order#
    --
FROM endpoints e
WHERE e.clients IS NOT NULL
UNION ALL
--
SELECT
    2 AS lvl,
    --
    tsk_nav.get_link(t.page_label, in_page_id => t.page_id) AS attribute01,
    --
    '' AS attribute02,
    '' AS attribute03,
    '' AS attribute04,
    '' AS attribute05,
    '' AS attribute06,
    '' AS attribute07,
    '' AS attribute08,
    '' AS attribute09,
    ' class="NAV_L3"' AS attribute10,
    --
    e.clients || '/1/' || t.order# || '.' || t.page_id AS order#
    --
FROM endpoints e
JOIN (
    SELECT 300 AS page_id, 'Projects'       AS page_label, 1 AS order# FROM DUAL UNION ALL
    SELECT 510 AS page_id, 'Repositories'   AS page_label, 2 AS order# FROM DUAL UNION ALL
    SELECT 210 AS page_id, 'Sequences'      AS page_label, 3 AS order# FROM DUAL
) t
    ON e.clients IS NOT NULL;
--
COMMENT ON TABLE tsk_navigation_clients_v IS '';

