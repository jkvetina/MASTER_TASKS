CREATE UNIQUE INDEX pk_tsk_commits
    ON tsk_commits (commit_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

