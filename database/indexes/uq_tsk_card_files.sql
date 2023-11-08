CREATE UNIQUE INDEX uq_tsk_card_files
    ON tsk_card_files (card_id, file_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

