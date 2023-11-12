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



    FUNCTION get_swimlane_name (
        in_swimlane_id      tsk_swimlanes.swimlane_id%TYPE := NULL
    )
    RETURN tsk_swimlanes.swimlane_name%TYPE;



    FUNCTION get_status_id
    RETURN tsk_statuses.status_id%TYPE;



    FUNCTION get_status_name (
        in_status_id        tsk_statuses.status_id%TYPE := NULL
    )
    RETURN tsk_statuses.status_name%TYPE;



    FUNCTION get_category_id
    RETURN tsk_categories.category_id%TYPE;



    FUNCTION get_category_name (
        in_category_id      tsk_categories.category_id%TYPE := NULL
    )
    RETURN tsk_categories.category_name%TYPE;



    FUNCTION get_owner_id
    RETURN tsk_cards.owner_id%TYPE;



    FUNCTION get_owner_name (
        in_owner_id         tsk_cards.owner_id%TYPE := NULL
    )
    RETURN VARCHAR2;



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
        in_swimlane_id      tsk_recent.swimlane_id%TYPE     := NULL,
        in_status_id        tsk_recent.status_id%TYPE       := NULL,
        in_category_id      tsk_recent.category_id%TYPE     := NULL,
        in_owner_id         tsk_recent.owner_id%TYPE        := NULL
    );



    FUNCTION get_card_next_sequence (
        in_sequence_id      tsk_sequences.sequence_id%TYPE,
        in_client_id        tsk_sequences.client_id%TYPE        := NULL
    )
    RETURN tsk_cards.card_number%TYPE;



    FUNCTION get_card_sequence (
        in_card_number      tsk_cards.card_number%TYPE,
        in_client_id        tsk_cards.client_id%TYPE        := NULL
    )
    RETURN tsk_sequences.sequence_id%TYPE;

END;
/

