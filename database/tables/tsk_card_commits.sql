CREATE TABLE tsk_card_commits (
    card_id                         NUMBER(10,0)          CONSTRAINT nn_tsk_card_commits_card NOT NULL,
    commit_id                       VARCHAR2(64)          CONSTRAINT nn_tsk_card_commits_commit NOT NULL,
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT pk_tsk_card_commits
        PRIMARY KEY (
            card_id,
            commit_id
        ),
    --
    CONSTRAINT fk_tsk_card_commits_commit
        FOREIGN KEY (commit_id)
        REFERENCES tsk_commits (commit_id)
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_card_commits_card
        FOREIGN KEY (card_id)
        REFERENCES tsk_cards (card_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE tsk_card_commits IS '';
--
COMMENT ON COLUMN tsk_card_commits.card_id      IS '';
COMMENT ON COLUMN tsk_card_commits.commit_id    IS '';

