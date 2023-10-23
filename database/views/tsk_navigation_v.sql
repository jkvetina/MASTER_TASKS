CREATE OR REPLACE FORCE VIEW tsk_navigation_v AS
WITH curr AS (
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
SELECT t.*
FROM tsk_navigation_clients_v t
UNION ALL
--
SELECT t.*
FROM tsk_navigation_projects_v t
UNION ALL
--
SELECT t.*
FROM tsk_navigation_boards_v t;

