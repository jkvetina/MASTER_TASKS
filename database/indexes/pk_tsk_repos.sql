CREATE UNIQUE INDEX pk_tsk_repos
    ON tsk_repos (repo_id, owner_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

