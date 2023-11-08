CREATE UNIQUE INDEX pk_tsk_swimlanes
    ON tsk_swimlanes (client_id, project_id, swimlane_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

