CREATE UNIQUE INDEX uq_tsk_card_files_name
    ON tsk_card_files (card_id, file_name)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

