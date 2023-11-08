CREATE UNIQUE INDEX pk_tsk_cards
    ON tsk_cards (card_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

