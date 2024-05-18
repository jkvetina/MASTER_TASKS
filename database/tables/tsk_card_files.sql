CREATE TABLE tsk_card_files (
    card_id                         NUMBER(10,0)          CONSTRAINT nn_tsk_card_files_card NOT NULL,
    file_id                         NUMBER(10,0)          CONSTRAINT nn_tsk_card_files_id NOT NULL,
    file_name                       VARCHAR2(256)         CONSTRAINT nn_tsk_card_files_name NOT NULL,
    file_mime                       VARCHAR2(256)         CONSTRAINT nn_tsk_card_files_mime NOT NULL,
    file_size                       NUMBER                CONSTRAINT nn_tsk_card_files_len NOT NULL,
    file_payload                    BLOB,
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT pk_tsk_card_files
        PRIMARY KEY (file_id),
    --
    CONSTRAINT uq_tsk_card_files
        UNIQUE (
            card_id,
            file_id
        ),
    --
    CONSTRAINT uq_tsk_card_files_name
        UNIQUE (
            card_id,
            file_name
        ),
    --
    CONSTRAINT fk_tsk_card_files_card
        FOREIGN KEY (card_id)
        REFERENCES tsk_cards (card_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE tsk_card_files IS '';
--
COMMENT ON COLUMN tsk_card_files.card_id        IS '';
COMMENT ON COLUMN tsk_card_files.file_id        IS '';
COMMENT ON COLUMN tsk_card_files.file_name      IS '';
COMMENT ON COLUMN tsk_card_files.file_mime      IS '';
COMMENT ON COLUMN tsk_card_files.file_size      IS '';
COMMENT ON COLUMN tsk_card_files.file_payload   IS '';

