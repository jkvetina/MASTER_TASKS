CREATE OR REPLACE FORCE VIEW tsk_available_clients_v AS
SELECT
    u.app_id,
    u.user_id,
    c.client_id,
    c.client_name,
    c.is_active
    --
FROM tsk_clients c
CROSS JOIN app_user_v u
WHERE c.is_active       = 'Y';
--
COMMENT ON TABLE tsk_available_clients_v IS '';

