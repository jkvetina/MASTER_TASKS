CREATE OR REPLACE FORCE VIEW tsk_navigation_projects_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()   AS app_id,
        core.get_user_id()  AS user_id,
        --
        n.order#            AS endpoint
        --
    FROM app_navigation_v n
    WHERE n.app_id          = core.get_app_id()
        AND n.page_id       = 300  -- projects
),
counts AS (
    SELECT /*+ MATERIALIZE */
        c.project_id,
        COUNT(*)            AS row_count
        --
    FROM tsk_cards c
    JOIN tsk_available_projects_v a
        ON a.project_id     = c.project_id
    GROUP BY
        c.project_id
),
filter_data AS (
    SELECT DISTINCT /*+ MATERIALIZE */
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
            in_icon_name    => CASE WHEN a.is_current = 'Y' THEN 'fa-arrow-circle-right' END,
            in_badge        => c.row_count
        ) AS attribute01,
        --
        ' class="NAV_L3' || REPLACE(a.is_current, 'Y', ' ACTIVE') || '"' AS attribute10,
        --
        x.endpoint || '/0/' || a.order# AS order#
        --
    FROM tsk_available_projects_v a
    CROSS JOIN x
    LEFT JOIN counts c
        ON c.project_id         = a.project_id
    WHERE a.is_current_client   = 'Y'
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


