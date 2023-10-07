CREATE OR REPLACE PACKAGE tsk_tapi AS

    g_app_prefix            CONSTANT VARCHAR2(16)   := 'TSK';



    PROCEDURE clients (
        rec                     IN OUT NOCOPY   tsk_clients%ROWTYPE,
        --
        in_action               CHAR                            := NULL,
        in_client_id            tsk_clients.client_id%TYPE      := NULL
    );



    PROCEDURE clients_d (
        in_client_id            tsk_clients.client_id%TYPE
    );



    PROCEDURE projects (
        rec                 IN OUT NOCOPY   tsk_projects%ROWTYPE,
        --
        in_action           CHAR                                := NULL,
        in_client_id        tsk_projects.client_id%TYPE         := NULL,
        in_project_id       tsk_projects.project_id%TYPE        := NULL
    );



    PROCEDURE projects_d (
        in_client_id        tsk_projects.client_id%TYPE,
        in_project_id       tsk_projects.project_id%TYPE
    );



    PROCEDURE boards (
        rec                 IN OUT NOCOPY   tsk_boards%ROWTYPE,
        --
        in_action           CHAR                            := NULL,
        in_board_id         tsk_boards.board_id%TYPE        := NULL
    );



    PROCEDURE boards_d (
        in_board_id         tsk_boards.board_id%TYPE
    );



    PROCEDURE statuses (
        rec                     IN OUT NOCOPY   tsk_statuses%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_statuses.client_id%TYPE             := NULL,
        in_project_id           tsk_statuses.project_id%TYPE            := NULL,
        in_status_id            tsk_statuses.status_id%TYPE             := NULL
    );



    PROCEDURE statuses_d (
        in_client_id            tsk_statuses.client_id%TYPE,
        in_project_id           tsk_statuses.project_id%TYPE,
        in_status_id            tsk_statuses.status_id%TYPE
    );



    PROCEDURE swimlanes (
        rec                     IN OUT NOCOPY   tsk_swimlanes%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_swimlanes.client_id%TYPE            := NULL,
        in_project_id           tsk_swimlanes.project_id%TYPE           := NULL,
        in_swimlane_id          tsk_swimlanes.swimlane_id%TYPE          := NULL
    );



    PROCEDURE swimlanes_d (
        in_client_id            tsk_swimlanes.client_id%TYPE,
        in_project_id           tsk_swimlanes.project_id%TYPE,
        in_swimlane_id          tsk_swimlanes.swimlane_id%TYPE
    );



    PROCEDURE categories (
        rec                     IN OUT NOCOPY   tsk_categories%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_categories.client_id%TYPE           := NULL,
        in_project_id           tsk_categories.project_id%TYPE          := NULL,
        in_category_id          tsk_categories.category_id%TYPE         := NULL
    );



    PROCEDURE categories_d (
        in_client_id            tsk_categories.client_id%TYPE,
        in_project_id           tsk_categories.project_id%TYPE,
        in_category_id          tsk_categories.category_id%TYPE
    );



    PROCEDURE cards (
        rec                     IN OUT NOCOPY   tsk_cards%ROWTYPE,
        in_action                               CHAR                                := NULL
    );



    PROCEDURE cards_delete (
        in_card_id              tsk_cards.card_id%TYPE
    );



    PROCEDURE user_fav_boards (
        rec                     IN OUT NOCOPY   tsk_boards_fav%ROWTYPE,
        in_action                               CHAR                                := NULL
    );



    PROCEDURE commits (
        rec                     IN OUT NOCOPY   tsk_commits%ROWTYPE,
        --
        in_action               CHAR                            := NULL
    );



    PROCEDURE card_commits (
        rec                     IN OUT NOCOPY   tsk_card_commits%ROWTYPE,
        --
        in_action               CHAR                            := NULL,
        in_commit_id            tsk_card_commits.commit_id%TYPE := NULL,
        in_card_id              tsk_card_commits.card_id%TYPE   := NULL
    );



    PROCEDURE card_comments (
        rec                     IN OUT NOCOPY   tsk_card_comments%ROWTYPE,
        --
        in_action               CHAR                                        := NULL,
        in_card_id              tsk_card_comments.card_id%TYPE              := NULL,
        in_comment_id           tsk_card_comments.comment_id%TYPE           := NULL
    );



    PROCEDURE card_files (
        rec                 IN OUT NOCOPY   tsk_card_files%ROWTYPE,
        --
        in_action           CHAR                                    := NULL,
        in_file_id          tsk_card_files.file_id%TYPE             := NULL
    );



    PROCEDURE repos (
        rec                     IN OUT NOCOPY   tsk_repos%ROWTYPE,
        --
        in_action               CHAR                                := NULL,
        in_repo_id              tsk_repos.repo_id%TYPE              := NULL,
        in_owner_id             tsk_repos.owner_id%TYPE             := NULL
    );



    PROCEDURE repos_d (
        in_repo_id              tsk_repos.repo_id%TYPE,
        in_owner_id             tsk_repos.owner_id%TYPE
    );



    PROCEDURE repo_endpoints (
        rec                     IN OUT NOCOPY   tsk_repo_endpoints%ROWTYPE,
        --
        in_action               CHAR                                        := NULL,
        in_repo_id              tsk_repo_endpoints.repo_id%TYPE             := NULL,
        in_owner_id             tsk_repo_endpoints.owner_id%TYPE            := NULL
    );



    PROCEDURE repo_endpoints_d (
        in_repo_id              tsk_repo_endpoints.repo_id%TYPE,
        in_owner_id             tsk_repo_endpoints.owner_id%TYPE
    );



    PROCEDURE save_recent (
        rec                 IN OUT NOCOPY   tsk_recent%ROWTYPE
    );

END;
/

