CREATE OR REPLACE PACKAGE BODY tsk_tapi AS

    PROCEDURE clients (
        rec                     IN OUT NOCOPY   tsk_clients%ROWTYPE,
        --
        in_action               CHAR                            := NULL,
        in_client_id            tsk_clients.client_id%TYPE      := NULL
    )
    AS
        c_action                CONSTANT CHAR   := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            -- allow to delete only client without any data
            DELETE FROM tsk_clients         WHERE client_id = in_client_id;
            --
            RETURN;
        END IF;

        -- upsert record
        UPDATE tsk_clients t
        SET ROW             = rec
        WHERE t.client_id   = rec.client_id;
        --
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tsk_clients VALUES rec;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE projects (
        rec                 IN OUT NOCOPY   tsk_projects%ROWTYPE,
        --
        in_action           CHAR                                := NULL,
        in_client_id        tsk_projects.client_id%TYPE         := NULL,
        in_project_id       tsk_projects.project_id%TYPE        := NULL
    )
    AS
        c_action            CONSTANT CHAR                       := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            -- need to be sorted properly
            DELETE FROM tsk_milestones      WHERE client_id = in_client_id AND project_id = in_project_id;
            DELETE FROM tsk_boards_fav      WHERE client_id = in_client_id AND project_id = in_project_id;
            DELETE FROM tsk_boards          WHERE client_id = in_client_id AND project_id = in_project_id;
            DELETE FROM tsk_categories      WHERE client_id = in_client_id AND project_id = in_project_id;
            DELETE FROM tsk_repos           WHERE client_id = in_client_id AND project_id = in_project_id;
            DELETE FROM tsk_statuses        WHERE client_id = in_client_id AND project_id = in_project_id;
            DELETE FROM tsk_projects        WHERE client_id = in_client_id AND project_id = in_project_id;
            --DELETE FROM tsk_cards           WHERE client_id = in_client_id AND project_id = in_project_id;
            --
            RETURN;  -- exit procedure
        END IF;

        -- upsert record
        UPDATE tsk_projects t
        SET ROW = rec
        WHERE t.client_id           = rec.client_id
            AND t.project_id        = rec.project_id;
        --
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tsk_projects
            VALUES rec;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE boards (
        rec                 IN OUT NOCOPY   tsk_boards%ROWTYPE,
        --
        in_action           CHAR                            := NULL,
        in_board_id         tsk_boards.board_id%TYPE        := NULL
    )
    AS
        c_action            CONSTANT CHAR                   := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            -- need to be sorted properly
            DELETE FROM tsk_boards_fav      WHERE board_id = in_board_id;
            DELETE FROM tsk_boards          WHERE board_id = in_board_id;
            --DELETE FROM tsk_cards           WHERE board_id = in_board_id;
            --
            RETURN;  -- exit procedure
        END IF;

        -- generate primary key if needed
        IF c_action = 'C' AND rec.board_id IS NULL THEN
            INSERT INTO tsk_boards
            VALUES rec;
        ELSE
            UPDATE tsk_boards t
            SET ROW = rec
            WHERE t.board_id            = rec.board_id;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE statuses (
        rec                     IN OUT NOCOPY   tsk_statuses%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_statuses.client_id%TYPE             := NULL,
        in_project_id           tsk_statuses.project_id%TYPE            := NULL,
        in_status_id            tsk_statuses.status_id%TYPE             := NULL
    )
    AS
        c_action                CONSTANT CHAR                           := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            -- need to be sorted properly
            DELETE FROM tsk_statuses                    WHERE client_id = in_client_id AND project_id = in_project_id AND status_id = in_status_id;
            --DELETE FROM tsk_cards                       WHERE client_id = in_client_id AND project_id = in_project_id AND status_id = in_status_id;
            --
            RETURN;  -- exit procedure
        END IF;

        -- upsert record
        UPDATE tsk_statuses t
        SET ROW = rec
        WHERE t.client_id               = rec.client_id
            AND t.project_id            = rec.project_id
            AND t.status_id             = rec.status_id;
        --
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tsk_statuses
            VALUES rec;
        END IF;

        -- keep just one is_default row
        IF rec.is_default = 'Y' THEN
            UPDATE tsk_statuses t
            SET t.is_default        = NULL
            WHERE t.client_id       = rec.client_id
                AND t.project_id    = rec.project_id
                AND t.status_id     != rec.status_id
                AND t.is_default    = 'Y';
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE milestones (
        rec                     IN OUT NOCOPY   tsk_milestones%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_milestones.client_id%TYPE           := NULL,
        in_project_id           tsk_milestones.project_id%TYPE          := NULL,
        in_milestone_id         tsk_milestones.milestone_id%TYPE        := NULL
    )
    AS
        c_action                CONSTANT CHAR                           := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            -- need to be sorted properly
            DELETE FROM tsk_boards_fav      WHERE client_id = in_client_id AND project_id = in_project_id;
            DELETE FROM tsk_milestones      WHERE client_id = in_client_id AND project_id = in_project_id AND milestone_id = in_milestone_id;
            --DELETE FROM tsk_cards           WHERE client_id = in_client_id AND project_id = in_project_id AND milestone_id = in_milestone_id;
            --
            RETURN;  -- exit procedure
        END IF;

        -- upsert record
        UPDATE tsk_milestones t
        SET ROW = rec
        WHERE t.client_id               = rec.client_id
            AND t.project_id            = rec.project_id
            AND t.milestone_id          = rec.milestone_id;
        --
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tsk_milestones
            VALUES rec;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE categories (
        rec                     IN OUT NOCOPY   tsk_categories%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_categories.client_id%TYPE           := NULL,
        in_project_id           tsk_categories.project_id%TYPE          := NULL,
        in_category_id          tsk_categories.category_id%TYPE         := NULL
    )
    AS
        c_action                CONSTANT CHAR                           := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            -- need to be sorted properly
            DELETE FROM tsk_categories                  WHERE client_id = in_client_id AND project_id = in_project_id AND category_id = in_category_id;
            --DELETE FROM tsk_cards                       WHERE client_id = in_client_id AND project_id = in_project_id AND category_id = in_category_id;
            --
            RETURN;  -- exit procedure
        END IF;

        -- upsert record
        UPDATE tsk_categories t
        SET ROW = rec
        WHERE t.client_id               = rec.client_id
            AND t.project_id            = rec.project_id
            AND t.category_id           = rec.category_id;
        --
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tsk_categories
            VALUES rec;
        END IF;

        -- keep just one is_default row
        IF rec.is_default = 'Y' THEN
            UPDATE tsk_categories t
            SET t.is_default        = NULL
            WHERE t.client_id       = rec.client_id
                AND t.project_id    = rec.project_id
                AND t.category_id   != rec.category_id
                AND t.is_default    = 'Y';
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE sequences (
        rec                     IN OUT NOCOPY   tsk_sequences%ROWTYPE,
        --
        in_action               CHAR                                    := NULL,
        in_client_id            tsk_sequences.client_id%TYPE            := NULL,
        in_sequence_id          tsk_sequences.sequence_id%TYPE          := NULL
    )
    AS
        c_action                CONSTANT CHAR                           := core_tapi.get_action(in_action);
    BEGIN
        -- upsert record
        UPDATE tsk_sequences t
        SET ROW = rec
        WHERE t.client_id       = rec.client_id
            AND t.sequence_id   = rec.sequence_id;
        --
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tsk_sequences
            VALUES rec;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE cards (
        rec                     IN OUT NOCOPY   tsk_cards%ROWTYPE,
        in_action                               CHAR                                := NULL
    )
    AS
        c_action                CONSTANT CHAR   := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            /*
            -- keep here to quickly check if we are not missing any tables
            SELECT c.table_name c
            FROM user_tab_cols c
            JOIN user_tables t
                ON t.table_name = c.table_name
            WHERE c.column_name = 'CARD_ID'
            ORDER BY 1;
            */

            DELETE FROM tsk_card_comments t
            WHERE t.card_id = rec.card_id;
            --
            DELETE FROM tsk_card_commits t
            WHERE t.card_id = rec.card_id;
            --
            DELETE FROM tsk_card_checklist t
            WHERE t.card_id = rec.card_id;
            --
            DELETE FROM tsk_card_files t
            WHERE t.card_id = rec.card_id;
            --
            DELETE FROM tsk_cards t
            WHERE t.card_id = rec.card_id;
            --
            RETURN;
        END IF;

        -- overwrite some values
        rec.tags        := NULLIF(':' || SUBSTR(REGEXP_REPLACE(LOWER(rec.tags), '[^a-z0-9]+', ':'), 1, 256) || ':', '::');

        -- proceed with update or insert
        IF rec.card_id IS NULL THEN
            INSERT INTO tsk_cards
            VALUES rec;
        ELSE
            UPDATE tsk_cards t
            SET ROW = rec
            WHERE t.card_id = rec.card_id;
            --
            IF SQL%ROWCOUNT = 0 THEN
                BEGIN
                    INSERT INTO tsk_cards
                    VALUES rec;
                EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    core.raise_error('UPDATE_FAILED');
                END;
            END IF;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE user_fav_boards (
        rec                     IN OUT NOCOPY   tsk_boards_fav%ROWTYPE,
        in_action                               CHAR                                := NULL
    )
    AS
        c_action                CONSTANT CHAR   := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            DELETE FROM tsk_boards_fav b
            WHERE b.user_id         = rec.user_id
                AND b.client_id     = rec.client_id
                AND b.project_id    = rec.project_id
                AND b.board_id      = rec.board_id;
            --
            RETURN;
        END IF;

        -- proceed with update or insert
        BEGIN
            INSERT INTO tsk_boards_fav VALUES rec;
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL;
        END;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE commits (
        rec                     IN OUT NOCOPY   tsk_commits%ROWTYPE,
        --
        in_action               CHAR                            := NULL
    )
    AS
        c_action                CONSTANT CHAR   := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            DELETE FROM tsk_commits t
            WHERE t.commit_id   = rec.commit_id;
            --
            RETURN;
        END IF;
        --
        BEGIN
            INSERT INTO tsk_commits VALUES rec;
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL;
        END;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE card_commits (
        rec                     IN OUT NOCOPY   tsk_card_commits%ROWTYPE,
        --
        in_action               CHAR                            := NULL,
        in_commit_id            tsk_card_commits.commit_id%TYPE := NULL,
        in_card_id              tsk_card_commits.card_id%TYPE   := NULL
    )
    AS
        c_action                CONSTANT CHAR   := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            DELETE FROM tsk_card_commits t
            WHERE t.card_id         = NVL(in_card_id,       rec.card_id)
                AND t.commit_id     = NVL(in_commit_id,     rec.commit_id);
            --
            RETURN;
        END IF;

        -- upsert record
        BEGIN
            INSERT INTO tsk_card_commits VALUES rec;
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL;
        END;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE card_comments (
        rec                     IN OUT NOCOPY   tsk_card_comments%ROWTYPE,
        --
        in_action               CHAR                                        := NULL,
        in_card_id              tsk_card_comments.card_id%TYPE              := NULL,
        in_comment_id           tsk_card_comments.comment_id%TYPE           := NULL
    )
    AS
        c_action                CONSTANT CHAR                               := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            DELETE FROM tsk_card_comments
            WHERE card_id       = NVL(in_card_id, rec.card_id)
                AND comment_id  = NVL(in_comment_id, rec.comment_id);
            --
            RETURN;  -- exit procedure
        END IF;

        -- generate primary key if needed
        IF c_action = 'C' AND rec.comment_id IS NULL THEN
            INSERT INTO tsk_card_comments
            VALUES rec;
        ELSE
            UPDATE tsk_card_comments t
            SET ROW = rec
            WHERE t.card_id                 = rec.card_id
                AND t.comment_id            = rec.comment_id;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE card_files (
        rec                 IN OUT NOCOPY   tsk_card_files%ROWTYPE,
        --
        in_action           CHAR                                    := NULL,
        in_file_id          tsk_card_files.file_id%TYPE             := NULL
    )
    AS
        c_action            CONSTANT CHAR                           := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            DELETE FROM tsk_card_files
            WHERE file_id = NVL(in_file_id, rec.file_id);
            --
            RETURN;  -- exit procedure
        END IF;

        -- generate primary key if needed
        IF c_action = 'C' AND rec.file_id IS NULL THEN
            INSERT INTO tsk_card_files
            VALUES rec;
        ELSE
            UPDATE tsk_card_files t
            SET ROW = rec
            WHERE t.file_id             = rec.file_id;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE repos (
        rec                     IN OUT NOCOPY   tsk_repos%ROWTYPE,
        --
        in_action               CHAR                                := NULL,
        in_repo_id              tsk_repos.repo_id%TYPE              := NULL
    )
    AS
        c_action                CONSTANT CHAR                       := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            -- need to be sorted properly
            DELETE FROM tsk_repo_endpoints              WHERE repo_id = in_repo_id;
            DELETE FROM tsk_repos                       WHERE repo_id = in_repo_id;
            --
            RETURN;  -- exit procedure
        END IF;

        -- upsert record
        UPDATE tsk_repos t
        SET ROW = rec
        WHERE t.repo_id                 = rec.repo_id;
        --
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tsk_repos
            VALUES rec;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE repo_endpoints (
        rec                     IN OUT NOCOPY   tsk_repo_endpoints%ROWTYPE,
        --
        in_action               CHAR                                        := NULL,
        in_repo_id              tsk_repo_endpoints.repo_id%TYPE             := NULL
    )
    AS
        c_action                CONSTANT CHAR                               := core_tapi.get_action(in_action);
    BEGIN
        -- delete record
        IF c_action = 'D' THEN
            -- need to be sorted properly
            DELETE FROM tsk_repo_endpoints              WHERE repo_id = in_repo_id;
            --
            RETURN;  -- exit procedure
        END IF;

        -- upsert record
        UPDATE tsk_repo_endpoints t
        SET ROW = rec
        WHERE t.repo_id                 = rec.repo_id;
        --
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tsk_repo_endpoints
            VALUES rec;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;

END;
/

