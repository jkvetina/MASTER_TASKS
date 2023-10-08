CREATE TABLE tsk_cards (
    card_id                         NUMBER(10,0)    CONSTRAINT nn_tsk_cards_id NOT NULL,
    card_number                     VARCHAR2(16),
    card_name                       VARCHAR2(128)   CONSTRAINT nn_tsk_cards_name NOT NULL,
    card_desc                       VARCHAR2(4000),
    client_id                       VARCHAR2(32)    CONSTRAINT nn_tsk_cards_client NOT NULL,
    project_id                      VARCHAR2(32)    CONSTRAINT nn_tsk_cards_project NOT NULL,
    board_id                        NUMBER(10,0)    CONSTRAINT nn_tsk_cards_board NOT NULL,
    swimlane_id                     VARCHAR2(32)    CONSTRAINT nn_tsk_cards_swimlane NOT NULL,
    status_id                       VARCHAR2(32)    CONSTRAINT nn_tsk_cards_status NOT NULL,
    category_id                     VARCHAR2(32),
    owner_id                        VARCHAR2(128),
    deadline_at                     DATE,
    tags                            VARCHAR2(256),
    order#                          NUMBER(10,0),
    created_by                      VARCHAR2(128)   CONSTRAINT nn_tsk_cards_created_by NOT NULL,
    created_at                      DATE            CONSTRAINT nn_tsk_cards_created_at NOT NULL,
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT pk_tsk_cards
        PRIMARY KEY (card_id),
    --
    CONSTRAINT fk_tsk_cards_board
        FOREIGN KEY (board_id)
        REFERENCES tsk_boards (board_id)
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_cards_status
        FOREIGN KEY (client_id, project_id, status_id)
        REFERENCES tsk_statuses (client_id, project_id, status_id)
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_cards_swimlane
        FOREIGN KEY (client_id, project_id, swimlane_id)
        REFERENCES tsk_swimlanes (client_id, project_id, swimlane_id)
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_cards_category
        FOREIGN KEY (client_id, project_id, category_id)
        REFERENCES tsk_categories (client_id, project_id, category_id)
        DEFERRABLE INITIALLY DEFERRED,
    --
    CONSTRAINT fk_tsk_cards_owner
        FOREIGN KEY (owner_id)
        REFERENCES app_users (user_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE tsk_cards IS '';
--
COMMENT ON COLUMN tsk_cards.card_id         IS '';
COMMENT ON COLUMN tsk_cards.card_number     IS '';
COMMENT ON COLUMN tsk_cards.card_name       IS '';
COMMENT ON COLUMN tsk_cards.card_desc       IS '';
COMMENT ON COLUMN tsk_cards.client_id       IS '';
COMMENT ON COLUMN tsk_cards.project_id      IS '';
COMMENT ON COLUMN tsk_cards.board_id        IS '';
COMMENT ON COLUMN tsk_cards.swimlane_id     IS '';
COMMENT ON COLUMN tsk_cards.status_id       IS '';
COMMENT ON COLUMN tsk_cards.category_id     IS '';
COMMENT ON COLUMN tsk_cards.owner_id        IS '';
COMMENT ON COLUMN tsk_cards.deadline_at     IS '';
COMMENT ON COLUMN tsk_cards.tags            IS '';
COMMENT ON COLUMN tsk_cards.order#          IS '';

