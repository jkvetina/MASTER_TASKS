CREATE UNIQUE INDEX pk_tsk_repo_endpoint
    ON tsk_repo_endpoints (repo_id, owner_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

