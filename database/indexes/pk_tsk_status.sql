CREATE UNIQUE INDEX pk_tsk_status
    ON tsk_statuses (client_id, project_id, status_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

