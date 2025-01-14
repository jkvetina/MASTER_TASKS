CREATE TABLE tsk_card_comments (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_card_comments_nn_tenant_id NOT NULL,
    card_id                         NUMBER(10,0)          CONSTRAINT tsk_card_comments_nn_card_id NOT NULL,
    comment_id                      NUMBER(10,0)          GENERATED BY DEFAULT ON NULL AS IDENTITY START WITH 1000 CONSTRAINT tsk_card_comments_nn_comment_id NOT NULL,
    comment_payload                 VARCHAR2(4000),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT tsk_card_comments_pk
        PRIMARY KEY (
            tenant_id,
            card_id,
            comment_id
        ),
    --
    CONSTRAINT tsk_card_comments_uq
        UNIQUE (
            tenant_id,
            comment_id
        ),
    --
    CONSTRAINT tsk_card_comments_fk_cards
        FOREIGN KEY (
            tenant_id,
            card_id
        )
        REFERENCES tsk_cards (
            tenant_id,
            card_id
        )
);
--
COMMENT ON TABLE tsk_card_comments IS '';
--
COMMENT ON COLUMN tsk_card_comments.tenant_id           IS '';
COMMENT ON COLUMN tsk_card_comments.card_id             IS '';
COMMENT ON COLUMN tsk_card_comments.comment_id          IS '';
COMMENT ON COLUMN tsk_card_comments.comment_payload     IS '';

