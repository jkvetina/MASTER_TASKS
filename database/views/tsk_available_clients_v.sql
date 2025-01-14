CREATE OR REPLACE FORCE VIEW tsk_available_clients_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        core.get_context_app()  AS app_id,
        core.get_user_id()      AS user_id,
        --
        core.get_number_item('P0_CLIENT_ID')    AS client_id,
        core.get_number_item('P0_PROJECT_ID')   AS project_id,
        core.get_number_item('P0_BOARD_ID')     AS board_id
    FROM DUAL
)
SELECT
    x.app_id,
    x.user_id,
    c.client_id,
    c.client_name,
    c.is_active,
    --
    CASE WHEN c.client_id = x.client_id THEN 'Y' END AS is_current,
    --
    LPAD(ROW_NUMBER() OVER (ORDER BY c.client_name), 4, '0') AS order#
    --
FROM tsk_clients c
CROSS JOIN x
--
-- @TODO: need to map assigned clients
--
WHERE c.is_active       = 'Y';
/

