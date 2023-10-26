CREATE OR REPLACE FORCE VIEW tsk_navigation_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()           AS app_id,
        core.get_user_id()          AS user_id,
        core.get_item('$TRIP_ID')   AS trip_id
    FROM DUAL
)
SELECT
    n.lvl,                  -- use Master application navigation
    n.attribute01,
    n.attribute02,
    n.attribute03,
    n.attribute04,
    n.attribute05,
    n.attribute06,
    n.attribute07,
    n.attribute08,
    n.attribute09,
    n.attribute10,
    n.order#
FROM app_navigation_v n
UNION ALL
--
SELECT
    t.lvl, t.attribute01, t.attribute02, t.attribute03, t.attribute04, t.attribute05, t.attribute06, t.attribute07, t.attribute08, t.attribute09, t.attribute10, t.order#
FROM tsk_navigation_clients_v t
UNION ALL
--
SELECT
    t.lvl, t.attribute01, t.attribute02, t.attribute03, t.attribute04, t.attribute05, t.attribute06, t.attribute07, t.attribute08, t.attribute09, t.attribute10, t.order#
FROM tsk_navigation_projects_v t
UNION ALL
--
SELECT
    t.lvl, t.attribute01, t.attribute02, t.attribute03, t.attribute04, t.attribute05, t.attribute06, t.attribute07, t.attribute08, t.attribute09, t.attribute10, t.order#
FROM tsk_navigation_boards_v t
UNION ALL
--
SELECT
    t.lvl, t.attribute01, t.attribute02, t.attribute03, t.attribute04, t.attribute05, t.attribute06, t.attribute07, t.attribute08, t.attribute09, t.attribute10, t.order#
FROM tsk_navigation_swimlanes_v t
UNION ALL
--
SELECT
    t.lvl, t.attribute01, t.attribute02, t.attribute03, t.attribute04, t.attribute05, t.attribute06, t.attribute07, t.attribute08, t.attribute09, t.attribute10, t.order#
FROM tsk_navigation_statuses_v t
UNION ALL
--
SELECT
    t.lvl, t.attribute01, t.attribute02, t.attribute03, t.attribute04, t.attribute05, t.attribute06, t.attribute07, t.attribute08, t.attribute09, t.attribute10, t.order#
FROM tsk_navigation_categories_v t
UNION ALL
--
SELECT
    t.lvl, t.attribute01, t.attribute02, t.attribute03, t.attribute04, t.attribute05, t.attribute06, t.attribute07, t.attribute08, t.attribute09, t.attribute10, t.order#
FROM tsk_navigation_owners_v t;
--
COMMENT ON TABLE tsk_navigation_v IS '';

