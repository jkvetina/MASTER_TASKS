CREATE TABLE tsk_card_checklist (
    card_id                         NUMBER(10,0)          CONSTRAINT nn_tsk_card_checklist_card_id NOT NULL,
    checklist_id                    NUMBER(10,0)          CONSTRAINT nn_tsk_card_checklist_item_id NOT NULL,
    checklist_item                  VARCHAR2(256)         CONSTRAINT nn_tsk_card_checklist_item NOT NULL,
    checklist_done                  CHAR(1),
    checklist_level                 NUMBER(4,0),
    order#                          VARCHAR2(32),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT ch_tsk_card_checklist_done
        CHECK (
            checklist_done = 'Y' OR checklist_done IS NULL
        ),
    --
    CONSTRAINT pk_tsk_card_checklist
        PRIMARY KEY (checklist_id),
    --
    CONSTRAINT fk_tsk_card_checklist_card
        FOREIGN KEY (card_id)
        REFERENCES tsk_cards (card_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE tsk_card_checklist IS '';
--
COMMENT ON COLUMN tsk_card_checklist.card_id            IS '';
COMMENT ON COLUMN tsk_card_checklist.checklist_id       IS '';
COMMENT ON COLUMN tsk_card_checklist.checklist_item     IS '';
COMMENT ON COLUMN tsk_card_checklist.checklist_done     IS '';
COMMENT ON COLUMN tsk_card_checklist.checklist_level    IS '';
COMMENT ON COLUMN tsk_card_checklist.order#             IS '';

