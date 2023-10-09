CREATE OR REPLACE PACKAGE tsk_app AS

    /**
     * This package is part of the TASKS project under MIT licence.
     * https://github.com/jkvetina/
     *
     * Copyright (c) Jan Kvetina, 2023
     *
     *                                                      (R)
     *                      ---                  ---
     *                    #@@@@@@              &@@@@@@
     *                    @@@@@@@@     .@      @@@@@@@@
     *          -----      @@@@@@    @@@@@@,   @@@@@@@      -----
     *       &@@@@@@@@@@@    @@@   &@@@@@@@@@.  @@@@   .@@@@@@@@@@@#
     *           @@@@@@@@@@@   @  @@@@@@@@@@@@@  @   @@@@@@@@@@@
     *             \@@@@@@@@@@   @@@@@@@@@@@@@@@   @@@@@@@@@@
     *               @@@@@@@@@   @@@@@@@@@@@@@@@  &@@@@@@@@
     *                 @@@@@@@(  @@@@@@@@@@@@@@@  @@@@@@@@
     *                  @@@@@@(  @@@@@@@@@@@@@@,  @@@@@@@
     *                  .@@@@@,   @@@@@@@@@@@@@   @@@@@@
     *                   @@@@@@  *@@@@@@@@@@@@@   @@@@@@
     *                   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.
     *                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     *                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@
     *                     .@@@@@@@@@@@@@@@@@@@@@@@@@
     *                       .@@@@@@@@@@@@@@@@@@@@@
     *                            jankvetina.cz
     *                               -------
     *
     */



    PROCEDURE init_defaults;
    --
    PROCEDURE init_defaults_p100;



    FUNCTION get_client_id
    RETURN tsk_clients.client_id%TYPE;



    FUNCTION get_client_name (
        in_client_id        tsk_clients.client_id%TYPE := NULL
    )
    RETURN tsk_clients.client_name%TYPE;



    FUNCTION get_project_id
    RETURN tsk_projects.project_id%TYPE;



    FUNCTION get_project_name (
        in_project_id       tsk_projects.project_id%TYPE := NULL
    )
    RETURN tsk_projects.project_name%TYPE;



    FUNCTION get_board_id
    RETURN tsk_boards.board_id%TYPE;



    FUNCTION get_board_name (
        in_board_id         tsk_boards.board_id%TYPE := NULL
    )
    RETURN tsk_boards.board_name%TYPE;



    FUNCTION get_swimlane_id
    RETURN tsk_swimlanes.swimlane_id%TYPE;



    FUNCTION get_owner_id
    RETURN tsk_cards.owner_id%TYPE;



    PROCEDURE find_project (
        io_client_id        IN OUT NOCOPY tsk_recent.client_id%TYPE,
        io_project_id       IN OUT NOCOPY tsk_recent.project_id%TYPE,
        io_board_id         IN OUT NOCOPY tsk_recent.board_id%TYPE
    );



    PROCEDURE find_board (
        io_client_id        IN OUT NOCOPY tsk_recent.client_id%TYPE,
        io_project_id       IN OUT NOCOPY tsk_recent.project_id%TYPE,
        io_board_id         IN OUT NOCOPY tsk_recent.board_id%TYPE
    );



    PROCEDURE set_context (
        in_client_id        tsk_recent.client_id%TYPE       := NULL,
        in_project_id       tsk_recent.project_id%TYPE      := NULL,
        in_board_id         tsk_recent.board_id%TYPE        := NULL,
        in_swimlanes        tsk_recent.swimlanes%TYPE       := NULL,
        in_owners           tsk_recent.owners%TYPE          := NULL
    );



    FUNCTION get_link (
        in_content          VARCHAR2,
        in_client_id        tsk_recent.client_id%TYPE       := NULL,
        in_project_id       tsk_recent.project_id%TYPE      := NULL,
        in_board_id         tsk_recent.board_id%TYPE        := NULL,
        in_card_id          tsk_cards.card_id%TYPE          := NULL,
        in_class            VARCHAR2                        := NULL
    )
    RETURN VARCHAR2;



    FUNCTION get_page_link (
        in_page_id          NUMBER,
        in_content          VARCHAR2,
        in_class            VARCHAR2        := NULL
    )
    RETURN VARCHAR2;



    FUNCTION get_card_link (
        in_card_id          tsk_cards.card_id%TYPE,
        in_external         CHAR                        := NULL
    )
    RETURN VARCHAR2;



    PROCEDURE set_user_preferences (
        in_user_id          app_users.user_id%TYPE,
        in_client_id        tsk_clients.client_id%TYPE,
        in_project_id       tsk_projects.project_id%TYPE,
        in_board_id         tsk_boards.board_id%TYPE,
        in_swimlane_id      tsk_swimlanes.swimlane_id%TYPE      := NULL
    );



    PROCEDURE validate_user_preferences (
        io_user_id          IN OUT NOCOPY   app_users.user_id%TYPE,
        io_client_id        IN OUT NOCOPY   tsk_clients.client_id%TYPE,
        io_project_id       IN OUT NOCOPY   tsk_projects.project_id%TYPE,
        io_board_id         IN OUT NOCOPY   tsk_boards.board_id%TYPE,
        io_swimlane_id      IN OUT NOCOPY   tsk_swimlanes.swimlane_id%TYPE
    );



    PROCEDURE init_projects;



    FUNCTION get_card_next_sequence (
        in_sequence_id      tsk_sequences.sequence_id%TYPE,
        in_client_id        tsk_sequences.client_id%TYPE        := NULL
    )
    RETURN tsk_cards.card_number%TYPE;

END;
/

