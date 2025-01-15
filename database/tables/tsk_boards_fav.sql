CREATE TABLE tsk_boards_fav (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_boards_fav_nn_tenant_id NOT NULL,
    user_id                         VARCHAR2(128)         CONSTRAINT tsk_boards_fav_nn_user_id NOT NULL,
    client_id                       NUMBER(10,0)          CONSTRAINT tsk_boards_fav_nn_client_id NOT NULL,
    project_id                      NUMBER(10,0)          CONSTRAINT tsk_boards_fav_nn_project_id NOT NULL,
    board_id                        NUMBER(10,0)          CONSTRAINT tsk_boards_fav_nn_board_id NOT NULL,
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT tsk_boards_fav_pk
        PRIMARY KEY (
            tenant_id,
            user_id,
            client_id,
            project_id,
            board_id
        ),
    --
    CONSTRAINT tsk_boards_fav_fk_boards
        FOREIGN KEY (
            tenant_id,
            client_id,
            project_id,
            board_id
        )
        REFERENCES tsk_boards (
            tenant_id,
            client_id,
            project_id,
            board_id
        )
);
--
COMMENT ON TABLE tsk_boards_fav IS '';
--
COMMENT ON COLUMN tsk_boards_fav.tenant_id      IS '';
COMMENT ON COLUMN tsk_boards_fav.user_id        IS '';
COMMENT ON COLUMN tsk_boards_fav.client_id      IS '';
COMMENT ON COLUMN tsk_boards_fav.project_id     IS '';
COMMENT ON COLUMN tsk_boards_fav.board_id       IS '';

