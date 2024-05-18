CREATE OR REPLACE FORCE VIEW tsk_navigation_v AS
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
FROM tsk_navigation_home_v t
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
FROM tsk_navigation_boards_v t;
/

