CREATE OR REPLACE FORCE VIEW tsk_available_clients_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        u.app_id,
        u.user_id,
        tsk_app.get_client_id()     AS client_id,
        tsk_app.get_project_id()    AS project_id,
        tsk_app.get_board_id()      AS board_id
        --
    FROM app_user_v u
)
SELECT
    x.app_id,
    x.user_id,
    c.client_id,
    c.client_name,
    c.is_active,
    --
    CASE WHEN c.client_id = x.client_id THEN 'Y' END AS is_current
    --
FROM tsk_clients c
CROSS JOIN x
/*
--
-- @TODO: need to map assigned clients
--
JOIN tsk_auth_...
    ON a.user_id        = x.user_id
    AND a.client_id     = c.client_id
    AND a.is_active     = 'Y'
    --AND (?.user_id      = u.user_id OR u.is_admin = 'Y')
    */
WHERE c.is_active       = 'Y';
--
COMMENT ON TABLE tsk_available_clients_v IS '';

