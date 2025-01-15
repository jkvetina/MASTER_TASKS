CREATE TABLE tsk_sequences (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_sequences_nn_tenant_id NOT NULL,
    client_id                       NUMBER(10,0)          CONSTRAINT tsk_sequences_nn_client_id NOT NULL,
    project_id                      NUMBER(10,0)          CONSTRAINT tsk_sequences_nn_project_id NOT NULL,
    sequence_id                     VARCHAR2(32)          CONSTRAINT tsk_sequences_nn_sequence_id NOT NULL,
    sequence_desc                   VARCHAR2(256),
    is_active                       CHAR(1),
    order#                          NUMBER(4,0),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT tsk_sequences_ch_is_active
        CHECK (
            is_active = 'Y' OR is_active IS NULL
        ) ENABLE,
    --
    CONSTRAINT tsk_sequences_pk
        PRIMARY KEY (
            tenant_id,
            client_id,
            project_id,
            sequence_id
        ),
    --
    CONSTRAINT tsk_sequences_fk_projects
        FOREIGN KEY (
            tenant_id,
            client_id,
            project_id
        )
        REFERENCES tsk_projects (
            tenant_id,
            client_id,
            project_id
        )
);
--
COMMENT ON TABLE tsk_sequences IS '';
--
COMMENT ON COLUMN tsk_sequences.tenant_id       IS '';
COMMENT ON COLUMN tsk_sequences.client_id       IS '';
COMMENT ON COLUMN tsk_sequences.project_id      IS '';
COMMENT ON COLUMN tsk_sequences.sequence_id     IS '';
COMMENT ON COLUMN tsk_sequences.sequence_desc   IS '';
COMMENT ON COLUMN tsk_sequences.is_active       IS '';
COMMENT ON COLUMN tsk_sequences.order#          IS '';

