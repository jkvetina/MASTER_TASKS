CREATE OR REPLACE PACKAGE tsk_nav AS

    FUNCTION get_link (
        in_content          VARCHAR2,
        in_page_id          NUMBER,
        in_card_id          tsk_cards.card_id%TYPE          := NULL,
        in_client_id        tsk_recent.client_id%TYPE       := NULL,
        in_project_id       tsk_recent.project_id%TYPE      := NULL,
        in_board_id         tsk_recent.board_id%TYPE        := NULL,
        in_swimlanes        tsk_recent.swimlanes%TYPE       := NULL,
        in_owners           tsk_recent.owners%TYPE          := NULL,
        in_items            VARCHAR2                        := NULL,
        in_values           VARCHAR2                        := NULL,
        in_class            VARCHAR2                        := NULL,
        in_icon_name        VARCHAR2                        := NULL
    )
    RETURN VARCHAR2;



    FUNCTION get_home
    RETURN VARCHAR2;



    FUNCTION get_clients
    RETURN VARCHAR2;



    FUNCTION get_projects
    RETURN VARCHAR2;



    FUNCTION get_boards
    RETURN VARCHAR2;



    FUNCTION get_swimlanes
    RETURN VARCHAR2;



    FUNCTION get_statuses
    RETURN VARCHAR2;



    FUNCTION get_categories
    RETURN VARCHAR2;



    FUNCTION get_owners
    RETURN VARCHAR2;



    FUNCTION get_commits
    RETURN VARCHAR2;

END;
/

