CREATE OR REPLACE FORCE VIEW tsk_p100_tasks_v AS
WITH t AS (
    SELECT /*+ MATERIALIZE */
       t.*
       --
       -- @TODO: limit columns
       --
    FROM tsk_tasks t
    JOIN tsk_auth_context_v x
        ON x.client_id      = t.client_id
        AND x.project_id    = t.project_id
        AND x.board_id      = t.board_id
        --
        AND (x.swimlane_id  = t.swimlane_id OR x.swimlane_id IS NULL)
        AND (x.owner_id     = t.owner_id    OR x.owner_id IS NULL)
),
p AS (
    -- to calculate tasks progress
    SELECT /*+ MATERIALIZE */
        p.task_id,
        NULLIF(SUM(CASE WHEN p.checklist_done = 'Y' THEN 1 ELSE 0 END) || '/' || COUNT(p.checklist_id), '0/0') AS task_progress
    FROM tsk_task_checklist p
    JOIN t
        ON t.task_id        = p.task_id
    GROUP BY p.task_id
)
SELECT
    t.task_id,
    t.task_name,
    --
    APEX_PAGE.GET_URL (
        p_page          => 105,
        p_clear_cache   => 105,
        p_items         => 'P105_TASK_ID,P105_SOURCE_PAGE',
        p_values        => '' || t.task_id || ',100'
    ) AS task_link,
    --
    p.task_progress,
    --
    t.client_id,
    t.project_id,
    t.board_id,
    --
    t.status_id,
    t.swimlane_id,
    t.category_id,
    t.owner_id,
    t.deadline_at,
    --
    LTRIM(RTRIM(REPLACE(t.tags, ':', ' '))) AS tags,
    --
    g.color_bg,
    t.updated_by,
    t.updated_at,
    --
    LAG(t.task_id) OVER (
        PARTITION BY t.client_id, t.project_id, t.board_id
        ORDER BY w.order# NULLS LAST, s.order# NULLS LAST, t.order# NULLS LAST
    ) AS prev_task,
    --
    LEAD(t.task_id) OVER (
        PARTITION BY t.client_id, t.project_id, t.board_id
        ORDER BY w.order# NULLS LAST, s.order# NULLS LAST, t.order# NULLS LAST
    ) AS next_task,
    --
    w.order#            AS swimlane_order#,
    s.order#            AS status_order#,
    t.order#            AS task_order#,
    --
    ROW_NUMBER() OVER (ORDER BY t.order# NULLS LAST, t.task_id) AS order#
    --
FROM t
JOIN tsk_lov_statuses_v s
    ON s.status_id      = t.status_id
JOIN tsk_lov_swimlanes_v w
    ON w.swimlane_id    = t.swimlane_id
LEFT JOIN tsk_lov_categories_v g
    ON g.category_id    = t.category_id
    AND g.color_bg      IS NOT NULL
LEFT JOIN p
    ON p.task_id        = t.task_id;
--
COMMENT ON TABLE tsk_p100_tasks_v IS '';
