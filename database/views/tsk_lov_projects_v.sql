CREATE OR REPLACE FORCE VIEW tsk_lov_projects_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_board_id()      AS board_id
    FROM DUAL
)
SELECT
    t.client_id,
    t.client_name,
    t.project_id,
    t.project_name,
    --
    LPAD('0', ROW_NUMBER() OVER (
        PARTITION BY t.client_id
        ORDER BY t.project_name, t.project_id
        ), '0') AS order#,
    --
    t.is_current
    --
FROM tsk_available_projects_v t
JOIN x
    ON x.client_id      = t.client_id;
/

