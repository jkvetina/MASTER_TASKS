CREATE OR REPLACE FORCE VIEW tsk_navigation_clients_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()   AS app_id,
        core.get_user_id()  AS user_id,
        --
        n.order#            AS endpoint
        --
    FROM app_navigation_v n
    WHERE n.app_id          = core.get_app_id()
        AND n.page_id       = 200  -- clients
),
filter_data AS (
    SELECT DISTINCT /*+ MATERIALIZE */
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
        x.endpoint || '/0/' || a.order# AS order#
        --
    FROM tsk_available_clients_v a
    CROSS JOIN x
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
    --
    x.endpoint || '/0/' || t.order# AS order#
    --
FROM filter_data t
CROSS JOIN x
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
    x.endpoint || '/1/' AS order#
    --
FROM x
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
    x.endpoint || '/1/' || t.order# || '.' || t.page_id AS order#
    --
FROM x
CROSS JOIN (
    SELECT 300 AS page_id, 'Projects'       AS page_label, 1 AS order# FROM DUAL UNION ALL
    SELECT 510 AS page_id, 'Repositories'   AS page_label, 2 AS order# FROM DUAL UNION ALL
    SELECT 210 AS page_id, 'Sequences'      AS page_label, 3 AS order# FROM DUAL
) t;
--
COMMENT ON TABLE tsk_navigation_clients_v IS '';

