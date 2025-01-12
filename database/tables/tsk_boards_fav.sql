CREATE TABLE tsk_boards_fav (
    user_id                         VARCHAR2(128)         CONSTRAINT nn_tsk_boards_fav_user NOT NULL,
    client_id                       VARCHAR2(32)          CONSTRAINT nn_tsk_boards_fav_client NOT NULL,
    project_id                      VARCHAR2(32)          CONSTRAINT nn_tsk_boards_fav_project NOT NULL,
    board_id                        NUMBER(10,0)          CONSTRAINT nn_tsk_boards_fav_board NOT NULL,
    swimlane_id                     VARCHAR2(32),
    owner_id                        VARCHAR2(128),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT pk_tsk_boards_fav
        PRIMARY KEY (
            user_id,
            client_id,
            project_id,
            board_id
        ),
    --
    CONSTRAINT fk_tsk_boards_fav_board
        FOREIGN KEY (board_id)
        REFERENCES tsk_boards (board_id)
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_boards_fav_swim
        FOREIGN KEY (
            client_id,
            project_id,
            swimlane_id
        )
        REFERENCES tsk_swimlanes (
            client_id,
            project_id,
            swimlane_id
        )
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE tsk_boards_fav IS '';
--
COMMENT ON COLUMN tsk_boards_fav.user_id        IS '';
COMMENT ON COLUMN tsk_boards_fav.client_id      IS '';
COMMENT ON COLUMN tsk_boards_fav.project_id     IS '';
COMMENT ON COLUMN tsk_boards_fav.board_id       IS '';
COMMENT ON COLUMN tsk_boards_fav.swimlane_id    IS '';
COMMENT ON COLUMN tsk_boards_fav.owner_id       IS '';

