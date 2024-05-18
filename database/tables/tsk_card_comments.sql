CREATE TABLE tsk_card_comments (
    card_id                         NUMBER(10,0)          CONSTRAINT nn_tsk_card_comments_card NOT NULL,
    comment_id                      NUMBER(10,0)          CONSTRAINT nn_tsk_card_comments_id NOT NULL,
    comment_payload                 VARCHAR2(4000),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT pk_tsk_card_comments
        PRIMARY KEY (
            card_id,
            comment_id
        ),
    --
    CONSTRAINT fk_tsk_card_comments_card
        FOREIGN KEY (card_id)
        REFERENCES tsk_cards (card_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE tsk_card_comments IS '';
--
COMMENT ON COLUMN tsk_card_comments.card_id             IS '';
COMMENT ON COLUMN tsk_card_comments.comment_id          IS '';
COMMENT ON COLUMN tsk_card_comments.comment_payload     IS '';

