CREATE UNIQUE INDEX uq_tsk_boards
    ON tsk_boards (client_id, project_id, board_name)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

