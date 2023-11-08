CREATE UNIQUE INDEX pk_tsk_projects
    ON tsk_projects (client_id, project_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

