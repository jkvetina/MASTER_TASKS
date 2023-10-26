CREATE OR REPLACE FORCE VIEW tsk_lov_clients_v AS
SELECT
    t.client_id,
    t.client_name,
    --
    LPAD('0', ROW_NUMBER() OVER (ORDER BY t.client_name, t.client_id), '0') AS order#
    --
FROM tsk_available_clients_v t;
--
COMMENT ON TABLE tsk_lov_clients_v IS '';

