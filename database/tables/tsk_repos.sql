CREATE TABLE tsk_repos (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_repos_nn_tenant_id NOT NULL,
    repo_id                         NUMBER(10,0)          GENERATED BY DEFAULT ON NULL AS IDENTITY START WITH 1000 CONSTRAINT tsk_repos_nn_repo_id NOT NULL,
    client_id                       NUMBER(10,0)          CONSTRAINT tsk_repos_nn_client_id NOT NULL,
    project_id                      NUMBER(10,0)          CONSTRAINT tsk_repos_nn_project_id NOT NULL,
    branch_id                       VARCHAR2(64),
    api_type                        VARCHAR2(16)          CONSTRAINT tsk_repos_nn_api_type NOT NULL,
    api_token                       VARCHAR2(256)         CONSTRAINT tsk_repos_nn_api_token NOT NULL,
    last_synced_at                  DATE,
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT tsk_repos_pk
        PRIMARY KEY (
            tenant_id,
            repo_id
        ),
    --
    CONSTRAINT tsk_repos_fk_projects
        FOREIGN KEY (
            tenant_id,
            client_id,
            project_id
        )
        REFERENCES tsk_projects (
            tenant_id,
            client_id,
            project_id
        )
);
--
COMMENT ON TABLE tsk_repos IS '';
--
COMMENT ON COLUMN tsk_repos.tenant_id           IS '';
COMMENT ON COLUMN tsk_repos.repo_id             IS '';
COMMENT ON COLUMN tsk_repos.client_id           IS '';
COMMENT ON COLUMN tsk_repos.project_id          IS '';
COMMENT ON COLUMN tsk_repos.branch_id           IS '';
COMMENT ON COLUMN tsk_repos.api_type            IS '';
COMMENT ON COLUMN tsk_repos.api_token           IS '';
COMMENT ON COLUMN tsk_repos.last_synced_at      IS '';

