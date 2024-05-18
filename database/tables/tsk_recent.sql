CREATE TABLE tsk_recent (
    user_id                         VARCHAR2(128)         CONSTRAINT nn_tsk_recent_user NOT NULL,
    client_id                       VARCHAR2(32)          CONSTRAINT nn_tsk_recent_client NOT NULL,
    project_id                      VARCHAR2(32)          CONSTRAINT nn_tsk_recent_project NOT NULL,
    board_id                        NUMBER(10,0)          CONSTRAINT nn_tsk_recent_board NOT NULL,
    swimlane_id                     VARCHAR2(32),
    status_id                       VARCHAR2(32),
    category_id                     VARCHAR2(32),
    owner_id                        VARCHAR2(128),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT pk_tsk_recent
        PRIMARY KEY (
            user_id,
            client_id,
            project_id
        ),
    --
    CONSTRAINT fk_tsk_recent_user
        FOREIGN KEY (user_id)
        REFERENCES app_users (user_id)
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_recent_client
        FOREIGN KEY (client_id)
        REFERENCES tsk_clients (client_id)
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_recent_project
        FOREIGN KEY (
            client_id,
            project_id
        )
        REFERENCES tsk_projects (
            client_id,
            project_id
        )
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_recent_board
        FOREIGN KEY (board_id)
        REFERENCES tsk_boards (board_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE tsk_recent IS '';
--
COMMENT ON COLUMN tsk_recent.user_id        IS '';
COMMENT ON COLUMN tsk_recent.client_id      IS '';
COMMENT ON COLUMN tsk_recent.project_id     IS '';
COMMENT ON COLUMN tsk_recent.board_id       IS '';
COMMENT ON COLUMN tsk_recent.swimlane_id    IS '';
COMMENT ON COLUMN tsk_recent.status_id      IS '';
COMMENT ON COLUMN tsk_recent.category_id    IS '';
COMMENT ON COLUMN tsk_recent.owner_id       IS '';

