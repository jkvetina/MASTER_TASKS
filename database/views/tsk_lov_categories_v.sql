CREATE OR REPLACE FORCE VIEW tsk_lov_categories_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_category_id()   AS category_id
    FROM DUAL
)
SELECT
    t.category_id,
    t.category_name,
    t.category_group,
    t.color_bg,
    t.color_fg,
    t.is_default,
    --
    CASE WHEN x.category_id = t.category_id THEN 'Y' END AS is_current,
    --
    LPAD('0', ROW_NUMBER() OVER (
        PARTITION BY t.client_id, t.project_id
        ORDER BY t.category_group, t.order#, t.category_name
        ), '0') AS order#
    --
FROM tsk_categories t
CROSS JOIN x
JOIN tsk_lov_boards_v b
    ON b.client_id      = t.client_id
    AND b.project_id    = t.project_id
    AND b.is_current    = 'Y'
WHERE t.is_active       = 'Y';
/

