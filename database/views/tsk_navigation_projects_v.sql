CREATE OR REPLACE FORCE VIEW tsk_navigation_projects_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()           AS app_id,
        core.get_user_id()          AS user_id,
        core.get_item('$TRIP_ID')   AS trip_id
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
filter_projects AS (
    SELECT DISTINCT
        2 AS lvl,
        a.project_id,
        a.project_name,
        a.is_current,
        --
        tsk_nav.get_link (
            in_content      => a.project_name,
            in_page_id      => core.get_page_id(),
            in_client_id    => a.client_id,
            in_project_id   => a.project_id,
            in_class        => '',
            in_icon_name    => CASE WHEN a.is_current = 'Y' THEN 'fa-arrow-circle-right' END
        ) AS attribute01,
        --
        ' class="NAV_L3' || REPLACE(a.is_current, 'Y', ' ACTIVE') || '"' AS attribute10,
        --
        '/0.300.' || a.project_id AS order#
        --
    FROM tsk_available_projects_v a
    WHERE a.is_current_client = 'Y'
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-chevron-down') || ' &nbsp; Select Project</span>' AS attribute01,
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
    e.projects || '/0/' AS order#
    --
FROM endpoints e
WHERE e.projects IS NOT NULL
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
    e.projects || '/0/' || t.order# AS order#
    --
FROM filter_projects t
JOIN endpoints e
    ON e.projects IS NOT NULL
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
    '</ul><ul>' AS attribute08,
    '' AS attribute09,
    ' class="NAV_L2"' AS attribute10,
    --
    e.projects || '/1/' AS order#
    --
FROM endpoints e
WHERE e.projects IS NOT NULL
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
    e.projects || '/1/' || t.order# || '.' || t.page_id AS order#
    --
FROM endpoints e
JOIN (
    SELECT 400 AS page_id, 'Boards'         AS page_label, 1 AS order# FROM DUAL UNION ALL
    SELECT 310 AS page_id, 'Swimlanes'      AS page_label, 2 AS order# FROM DUAL UNION ALL
    SELECT 320 AS page_id, 'Statuses'       AS page_label, 3 AS order# FROM DUAL UNION ALL
    SELECT 340 AS page_id, 'Categories'     AS page_label, 4 AS order# FROM DUAL
) t
    ON e.projects IS NOT NULL;
--
COMMENT ON TABLE tsk_navigation_projects_v IS '';

