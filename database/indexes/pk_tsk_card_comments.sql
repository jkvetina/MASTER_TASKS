CREATE UNIQUE INDEX pk_tsk_card_comments
    ON tsk_card_comments (card_id, comment_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

