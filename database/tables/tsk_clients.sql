CREATE TABLE tsk_clients (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_clients_nn_tenant_id NOT NULL,
    client_id                       NUMBER(10,0)          GENERATED BY DEFAULT ON NULL AS IDENTITY START WITH 1000 CONSTRAINT tsk_clients_nn_client_id NOT NULL,
    client_name                     VARCHAR2(64)          CONSTRAINT tsk_clients_nn_client_name NOT NULL,
    is_active                       CHAR(1),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT tsk_clients_ch_is_active
        CHECK (
            is_active = 'Y' OR is_active IS NULL
        ) ENABLE,
    --
    CONSTRAINT tsk_clients_pk
        PRIMARY KEY (
            tenant_id,
            client_id
        )
);
--
COMMENT ON TABLE tsk_clients IS '';
--
COMMENT ON COLUMN tsk_clients.tenant_id     IS '';
COMMENT ON COLUMN tsk_clients.client_id     IS '';
COMMENT ON COLUMN tsk_clients.client_name   IS '';
COMMENT ON COLUMN tsk_clients.is_active     IS '';

