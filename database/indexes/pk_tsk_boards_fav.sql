CREATE UNIQUE INDEX pk_tsk_boards_fav
    ON tsk_boards_fav (user_id, client_id, project_id, board_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

