CREATE OR REPLACE PACKAGE tsk_tapi AS

    PROCEDURE clients (
        rec                     IN OUT NOCOPY   tsk_clients%ROWTYPE,
        --
        in_action               CHAR                            := NULL,
        in_client_id            tsk_clients.client_id%TYPE      := NULL
    );



    PROCEDURE projects (
        rec                 IN OUT NOCOPY   tsk_projects%ROWTYPE,
        --
        in_action           CHAR                                := NULL,
        in_client_id        tsk_projects.client_id%TYPE         := NULL,
        in_project_id       tsk_projects.project_id%TYPE        := NULL
    );



    PROCEDURE boards (
        rec                 IN OUT NOCOPY   tsk_boards%ROWTYPE,
        --
        in_action           CHAR                            := NULL,
        in_board_id         tsk_boards.board_id%TYPE        := NULL
    );



    PROCEDURE statuses (
        rec                     IN OUT NOCOPY   tsk_statuses%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_statuses.client_id%TYPE             := NULL,
        in_project_id           tsk_statuses.project_id%TYPE            := NULL,
        in_status_id            tsk_statuses.status_id%TYPE             := NULL
    );



    PROCEDURE milestones (
        rec                     IN OUT NOCOPY   tsk_milestones%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_milestones.client_id%TYPE           := NULL,
        in_project_id           tsk_milestones.project_id%TYPE          := NULL,
        in_milestone_id         tsk_milestones.milestone_id%TYPE        := NULL
    );



    PROCEDURE categories (
        rec                     IN OUT NOCOPY   tsk_categories%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_categories.client_id%TYPE           := NULL,
        in_project_id           tsk_categories.project_id%TYPE          := NULL,
        in_category_id          tsk_categories.category_id%TYPE         := NULL
    );



    PROCEDURE sequences (
        rec                     IN OUT NOCOPY   tsk_sequences%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_sequences.client_id%TYPE            := NULL,
        in_sequence_id          tsk_sequences.sequence_id%TYPE          := NULL
    );



    PROCEDURE cards (
        rec                     IN OUT NOCOPY   tsk_cards%ROWTYPE,
        in_action                               CHAR                                := NULL
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
        in_repo_id              tsk_repos.repo_id%TYPE              := NULL
    );



    PROCEDURE repo_endpoints (
        rec                     IN OUT NOCOPY   tsk_repo_endpoints%ROWTYPE,
        --
        in_action               CHAR                                        := NULL,
        in_repo_id              tsk_repo_endpoints.repo_id%TYPE             := NULL
    );

END;
/

