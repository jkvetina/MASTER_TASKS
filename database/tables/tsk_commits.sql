CREATE TABLE tsk_commits (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_commits_tenant_nn NOT NULL,
    repo_id                         NUMBER(10,0)          CONSTRAINT tsk_commits_repo_nn NOT NULL,
    commit_id                       VARCHAR2(64)          CONSTRAINT tsk_commits_id_nn NOT NULL,
    commit_message                  VARCHAR2(2000),
    commit_url                      VARCHAR2(512),
    is_processed                    CHAR(1),
    created_by                      VARCHAR2(128),
    created_at                      DATE,
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT tsk_commits_mapped_ch
        CHECK (
            is_processed = 'Y' OR is_processed IS NULL
        ) ENABLE,
    --
    CONSTRAINT tsk_commits_pk
        PRIMARY KEY (
            tenant_id,
            commit_id
        ),
    --
    CONSTRAINT tsk_commits_repo_fk
        FOREIGN KEY (
            tenant_id,
            repo_id
        )
        REFERENCES tsk_repos (
            tenant_id,
            repo_id
        )
);
--
COMMENT ON TABLE tsk_commits IS '';
--
COMMENT ON COLUMN tsk_commits.tenant_id         IS '';
COMMENT ON COLUMN tsk_commits.repo_id           IS '';
COMMENT ON COLUMN tsk_commits.commit_id         IS '';
COMMENT ON COLUMN tsk_commits.commit_message    IS '';
COMMENT ON COLUMN tsk_commits.commit_url        IS '';
COMMENT ON COLUMN tsk_commits.is_processed      IS '';

