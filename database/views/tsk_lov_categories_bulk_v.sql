CREATE OR REPLACE FORCE VIEW tsk_lov_categories_bulk_v AS
SELECT
    t.category_id,
    t.category_name,
    t.category_group,
    t.color_bg,
    t.color_fg,
    t.is_default,
    b.project_name || ' - ' || t.category_group AS group_name,
    --
    ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id ORDER BY t.order#, t.category_name) AS order#
    --
FROM tsk_categories t
JOIN tsk_lov_boards_bulk_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y'
WHERE t.is_active       = 'Y';
--
COMMENT ON TABLE tsk_lov_categories_bulk_v IS '';

