CREATE OR REPLACE FORCE VIEW tsk_categories_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
    FROM DUAL
)
SELECT
    t.client_id         AS old_client_id,
    t.project_id        AS old_project_id,
    t.category_id       AS old_category_id,
    --
    t.client_id,
    t.project_id,
    t.category_id,
    t.category_name,
    t.category_group,
    t.color_bg,
    t.color_fg,
    t.is_active,
    t.is_default,
    t.order#
    --
FROM tsk_categories t
JOIN tsk_available_projects_v a
    ON a.client_id      = t.client_id
    AND a.project_id    = t.project_id
JOIN x
    ON x.client_id      = a.client_id
    AND x.project_id    = a.project_id;
/

