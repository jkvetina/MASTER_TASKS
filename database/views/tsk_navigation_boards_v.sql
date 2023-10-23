CREATE OR REPLACE VIEW tsk_navigation_boards_v AS
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
filter_boards AS (
    SELECT
        2 AS lvl,
            a.is_current,
        --
        tsk_nav.get_link (
            in_content      => a.board_name,
            in_page_id      => core.get_page_id(),
            in_client_id    => a.client_id,
            in_project_id   => a.project_id,
            in_board_id     => a.board_id,
            in_class        => '',
            in_icon_name    => CASE WHEN a.is_current = 'Y' THEN 'fa-arrow-circle-right' END
        ) AS attribute01,
        --
        ' class="NAV_L3' || REPLACE(a.is_current, 'Y', ' ACTIVE') || '"' AS attribute10,
        --
        '/0.400.' || a.board_id AS order#
        --
    FROM tsk_available_boards_v a
    WHERE a.is_current_project = 'Y'
)
SELECT
    2 AS lvl,
    --
    '<span>' || core.get_icon('fa-chevron-down') || ' &nbsp; Select Board</span>' AS attribute01,
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
    e.boards || '/0/' AS order#
    --
FROM endpoints e
WHERE e.boards IS NOT NULL
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
    e.boards || '/0/' || t.order# AS order#
    --
FROM filter_boards t
JOIN endpoints e
    ON e.boards IS NOT NULL;

