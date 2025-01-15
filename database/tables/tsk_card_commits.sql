CREATE TABLE tsk_card_commits (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_card_commits_nn_tenant_id NOT NULL,
    card_id                         NUMBER(10,0)          CONSTRAINT tsk_card_commits_nn_card_id NOT NULL,
    commit_id                       VARCHAR2(64)          CONSTRAINT tsk_card_commits_nn_commit_id NOT NULL,
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT tsk_card_commits_pk
        PRIMARY KEY (
            tenant_id,
            card_id,
            commit_id
        ),
    --
    CONSTRAINT tsk_card_commits_fk_commits
        FOREIGN KEY (
            tenant_id,
            commit_id
        )
        REFERENCES tsk_commits (
            tenant_id,
            commit_id
        ),
    --
    CONSTRAINT tsk_card_commits_fk_cards
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
COMMENT ON TABLE tsk_card_commits IS '';
--
COMMENT ON COLUMN tsk_card_commits.tenant_id    IS '';
COMMENT ON COLUMN tsk_card_commits.card_id      IS '';
COMMENT ON COLUMN tsk_card_commits.commit_id    IS '';

