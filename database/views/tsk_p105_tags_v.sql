CREATE OR REPLACE FORCE VIEW tsk_p105_tags_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        t.task_id
    FROM tsk_p100_tasks_v t
    WHERE t.task_id = core.get_item('P105_TASK_ID')
--),
--g AS (
--    SELECT /*+ MATERIALIZE */
--        t.task_id,
--        i.COLUMN_VALUE AS tag
--    FROM t
--    CROSS JOIN APEX_STRING.SPLIT(LTRIM(RTRIM(t.tags, ':'), ':'), ':') i
)
SELECT
    t.task_id,
    --
    '#' || t.task_id || ' ' || t.task_name || ' ' || t.task_progress AS list_text,
    --
    t.updated_at || ' ' || t.updated_by AS list_supplemental,
    --
    NULL                AS list_counter,
    t.task_link         AS list_link
    --
FROM tsk_p100_tasks_v t;
--
COMMENT ON TABLE tsk_p105_tags_v IS '';
