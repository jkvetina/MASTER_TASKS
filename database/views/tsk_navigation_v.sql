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
UNION ALL
SELECT                      -- append extras
    curr.app_id,
    100                     AS page_id,
    NULL                    AS parent_id,
    NULL                    AS auth_scheme,
    NULL                    AS procedure_name,
    NULL                    AS label__,
    2                       AS lvl,
    --
    NULL AS label,
    '#'  AS target,
    --
    NULL AS is_current_list_entry,
    NULL AS image,
    NULL AS image_attribute,
    NULL AS image_alt_attribute,
    --
    'TRANSPARENT MANUAL' AS attribute01,
    NULL AS attribute02,
    NULL AS attribute03,
    NULL AS attribute04,
    --
    ' style="display: none !important;"' AS attribute05,
    --
    NULL AS attribute06,
    NULL AS attribute07,
    --
    '<div style="display: flex; padding-bottom: 1.5rem;">' ||
        '<div class="COL_1">' || tsk_app.generate_menu_favorites() || '</div>' ||
        '<div class="COL_2">' || tsk_app.generate_menu_current() || '</div>' ||
        --'<div class="COL_3"><a href="#" style="height: 3rem; padding-top: 1rem !important;"><span class="fa fa-filter"></span>&' || 'nbsp; <span style="">Filters</span></a></div>' ||
        '<div class="COL_4 NO_HOVER" style="padding-left: 2rem;"><a href="#" style="height: 3rem; padding-top: 1rem !important;"><span class="fa fa-search"></span>&' || 'nbsp; <span style="">Search for Cards</span></a><span style="padding: 0 0.5rem; margin-right: 1rem;"><input id="MENU_SEARCH" value="" /></span></div>' ||
    '</div>' AS attribute08,
    --
    NULL AS attribute09,
    NULL AS attribute10,
    --
    '/100.100/' AS order#
    --
FROM DUAL
CROSS JOIN curr;
--
COMMENT ON TABLE tsk_navigation_v IS '';

