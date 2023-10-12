CREATE OR REPLACE FORCE VIEW tsk_lov_categories_v AS
SELECT
    t.category_id,
    t.category_name,
    t.category_group,
    t.color_bg,
    t.color_fg,
    t.is_default,
    --
    ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id ORDER BY t.order#, t.category_name) AS order#
    --
FROM tsk_categories t
JOIN tsk_lov_boards_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y'
WHERE t.is_active       = 'Y';
--
COMMENT ON TABLE tsk_lov_categories_v IS '';

