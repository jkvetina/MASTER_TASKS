CREATE UNIQUE INDEX pk_tsk_recent
    ON tsk_recent (user_id, client_id, project_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

