CREATE UNIQUE INDEX pk_tsk_card_checklist
    ON tsk_card_checklist (checklist_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

