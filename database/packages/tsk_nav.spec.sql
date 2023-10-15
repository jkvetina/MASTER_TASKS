CREATE OR REPLACE PACKAGE tsk_nav AS

    FUNCTION get_link (
        in_content          VARCHAR2,
        in_page_id          NUMBER                          := NULL,
        in_card_id          tsk_cards.card_id%TYPE          := NULL,
        in_client_id        tsk_recent.client_id%TYPE       := NULL,
        in_project_id       tsk_recent.project_id%TYPE      := NULL,
        in_board_id         tsk_recent.board_id%TYPE        := NULL,
        in_swimlane_id      tsk_recent.swimlane_id%TYPE     := NULL,
        in_status_id        tsk_recent.status_id%TYPE       := NULL,
        in_category_id      tsk_recent.category_id%TYPE     := NULL,
        in_owner_id         tsk_recent.owner_id%TYPE        := NULL,
        in_items            VARCHAR2                        := NULL,
        in_values           VARCHAR2                        := NULL,
        in_class            VARCHAR2                        := NULL,
        in_icon_name        VARCHAR2                        := NULL
    )
    RETURN VARCHAR2;



    FUNCTION get_card_link (
        in_card_id          tsk_cards.card_id%TYPE,
        in_external         CHAR                        := NULL
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

