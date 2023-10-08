CREATE UNIQUE INDEX tsk_cards_card_number_uq
    ON tsk_cards (client_id, NVL(card_number,TO_CHAR(card_id)))
    COMPUTE STATISTICS
    TABLESPACE "DATA";

