CREATE UNIQUE INDEX pk_tsk_boards
    ON tsk_boards (board_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

