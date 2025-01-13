CREATE TABLE tsk_boards_fav (
    tenant_id                       VARCHAR2(64)          CONSTRAINT tsk_boards_fav_tenant_nn NOT NULL,
    user_id                         VARCHAR2(128)         CONSTRAINT tsk_boards_fav_user_nn NOT NULL,
    client_id                       NUMBER(10,0)          CONSTRAINT tsk_boards_fav_client_nn NOT NULL,
    project_id                      NUMBER(10,0)          CONSTRAINT tsk_boards_fav_project_nn NOT NULL,
    board_id                        NUMBER(10,0)          CONSTRAINT tsk_boards_fav_board_nn NOT NULL,
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
    CONSTRAINT tsk_boards_fav_board_fk
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

