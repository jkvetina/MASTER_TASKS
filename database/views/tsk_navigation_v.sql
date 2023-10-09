CREATE OR REPLACE FORCE VIEW tsk_navigation_v AS
WITH curr AS (
    SELECT /*+ MATERIALIZE */
        core.get_app_id()           AS app_id,
        core.get_user_id()          AS user_id,
        core.get_item('$TRIP_ID')   AS trip_id
    FROM DUAL
)
SELECT
    n.app_id,                   -- some extra columns for FE
    n.page_id,
    n.parent_id,
    n.auth_scheme,
    n.procedure_name,
    n.label__,
    --
    n.lvl,                      -- mandatory columns for APEX navigation
    n.label,
    n.target,
    n.is_current_list_entry,
    n.image,
    n.image_attribute,
    n.image_alt_attribute,
    n.attribute01,              -- <li class="...">
    n.attribute02,              -- <li>...<a>
    n.attribute03,              -- <a class="..."
    n.attribute04,              -- <a title="..."
    n.attribute05,              -- <a ...> // javascript onclick
    n.attribute06,              -- <a>... #TEXT</a>
    n.attribute07,              -- <a>#TEXT ...</a>
    n.attribute08,              -- </a>...
    n.attribute09,
    n.attribute10,
    n.order#
FROM app_navigation_v n
CROSS JOIN curr
WHERE (n.app_id != curr.app_id OR n.lvl = 1)    -- show just main pages
UNION ALL
--
SELECT                      -- append extras
    curr.app_id,
    t.page_id,
    NULL                    AS parent_id,
    NULL                    AS auth_scheme,
    NULL                    AS procedure_name,
    NULL                    AS label__,
    2                       AS lvl,
    --
    NULL AS label,
    '#'  AS target,
    NULL AS is_current_list_entry,
    NULL AS image,
    NULL AS image_attribute,
    NULL AS image_alt_attribute,
    --
    'TRANSPARENT MANUAL' AS attribute01,
    NULL AS attribute02,
    NULL AS attribute03,
    NULL AS attribute04,
    ' style="display: none !important;"' AS attribute05,
    NULL AS attribute06,
    NULL AS attribute07,
    '<div class="ROW" style="padding-bottom: 1.5rem;">' || t.payload || '</div>' AS attribute08,
    NULL AS attribute09,
    NULL AS attribute10,
    --
    '/' || t.page_id || '.' || t.page_id || '/' AS order#
    --
FROM (
    SELECT 100 AS page_id, tsk_nav.get_home()       AS payload FROM DUAL UNION ALL
    SELECT 200 AS page_id, tsk_nav.get_clients()    AS payload FROM DUAL UNION ALL
    SELECT 300 AS page_id, tsk_nav.get_projects()   AS payload FROM DUAL UNION ALL
    SELECT 400 AS page_id, tsk_nav.get_boards()     AS payload FROM DUAL UNION ALL
    SELECT 500 AS page_id, tsk_nav.get_commits()    AS payload FROM DUAL
) t
CROSS JOIN curr;
--
COMMENT ON TABLE tsk_navigation_v IS '';

