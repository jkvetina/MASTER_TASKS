CREATE TABLE tsk_sequences (
    client_id                       VARCHAR2(32)          CONSTRAINT nn_tsk_sequences_client NOT NULL,
    sequence_id                     VARCHAR2(32)          CONSTRAINT nn_tsk_sequences_id NOT NULL,
    sequence_desc                   VARCHAR2(256),
    is_active                       CHAR(1),
    order#                          NUMBER(4,0),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT ch_tsk_sequences_active
        CHECK (
            is_active = 'Y' OR is_active IS NULL
        ),
    --
    CONSTRAINT pk_tsk_sequences
        PRIMARY KEY (
            client_id,
            sequence_id
        ),
    --
    CONSTRAINT fk_tsk_sequences_client
        FOREIGN KEY (client_id)
        REFERENCES tsk_clients (client_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE tsk_sequences IS '';
--
COMMENT ON COLUMN tsk_sequences.client_id       IS '';
COMMENT ON COLUMN tsk_sequences.sequence_id     IS '';
COMMENT ON COLUMN tsk_sequences.sequence_desc   IS '';
COMMENT ON COLUMN tsk_sequences.is_active       IS '';
COMMENT ON COLUMN tsk_sequences.order#          IS '';

