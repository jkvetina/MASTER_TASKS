CREATE OR REPLACE FORCE VIEW tsk_p500_commits_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
    FROM DUAL
),
d AS (
    SELECT /*+ MATERIALIZE */
        t.card_id,
        c.commit_id,
        SUBSTR(c.commit_id, 1, 8) AS commit_short,
        c.commit_message,
        c.commit_url,
        c.created_by,
        TO_CHAR(c.created_at, 'YYYY-MM-DD HH24:MI') AS created_at,
        TO_CHAR(c.created_at, 'YYYY-MM-DD')         AS today
    FROM tsk_commits c
    CROSS JOIN x
    JOIN tsk_repos r
        ON r.client_id      = x.client_id
        AND r.project_id    = x.project_id
    LEFT JOIN tsk_card_commits t
        ON t.commit_id      = c.commit_id
),
z AS (
    SELECT
        d.today,
        LPAD(' ', ROW_NUMBER() OVER (ORDER BY d.today), ' ') || d.today AS today_desc
    FROM d
    GROUP BY d.today
)
SELECT
    d.card_id           AS old_card_id,
    d.commit_id         AS old_commit_id,
    --
    d.card_id,
    d.commit_id,
    d.commit_short,
    d.commit_message,
    d.commit_url,
    d.created_by,
    d.created_at,
    z.today_desc        AS today
FROM d
JOIN z
    ON z.today = d.today;
/

