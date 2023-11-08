CREATE UNIQUE INDEX pk_tsk_card_commits
    ON tsk_card_commits (card_id, commit_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

