CREATE TABLE tsk_sequences (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_sequences_tenant_nn NOT NULL,
    client_id                       NUMBER(10,0)          CONSTRAINT tsk_sequences_client_nn NOT NULL,
    project_id                      NUMBER(10,0)          CONSTRAINT tsk_sequences_project_nn NOT NULL,
    sequence_id                     VARCHAR2(32)          CONSTRAINT tsk_sequences_id_nn NOT NULL,
    sequence_desc                   VARCHAR2(256),
    is_active                       CHAR(1),
    order#                          NUMBER(4,0),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT tsk_sequences_active_ch
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
    CONSTRAINT tsk_sequences_project_fk
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

