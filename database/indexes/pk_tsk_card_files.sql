CREATE UNIQUE INDEX pk_tsk_card_files
    ON tsk_card_files (file_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

