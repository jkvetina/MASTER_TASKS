CREATE OR REPLACE PACKAGE BODY tsk_handlers AS

    PROCEDURE save_clients
    AS
        rec                 tsk_clients%ROWTYPE;
        in_action           CONSTANT CHAR := core.get_grid_action();
    BEGIN
        -- change record in table
        rec.client_id       := core.get_grid_data('CLIENT_ID');
        rec.client_name     := core.get_grid_data('CLIENT_NAME');
        rec.is_active       := core.get_grid_data('IS_ACTIVE');
        --
        tsk_tapi.clients(rec, in_action);
        --
        IF in_action = 'C' THEN
            core.set_item('P0_CLIENT_ID', rec.client_id);
        END IF;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_projects
    AS
        rec                 tsk_projects%ROWTYPE;
        in_action           CONSTANT CHAR := core.get_grid_action();
    BEGIN
        -- change record in table
        rec.client_id       := core.get_grid_data('CLIENT_ID');
        rec.project_id      := core.get_grid_data('PROJECT_ID');
        rec.project_name    := core.get_grid_data('PROJECT_NAME');
        rec.is_default      := core.get_grid_data('IS_DEFAULT');
        rec.is_active       := core.get_grid_data('IS_ACTIVE');
        --
        tsk_tapi.projects(rec, in_action);
        --
        IF in_action = 'C' THEN
            core.set_item('P0_CLIENT_ID',   rec.client_id);
            core.set_item('P0_PROJECT_ID',  rec.project_id);
        END IF;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_boards
    AS
        rec                 tsk_boards%ROWTYPE;
        in_action           CONSTANT CHAR := core.get_grid_action();
    BEGIN
        -- change record in table
        rec.client_id       := core.get_grid_data('CLIENT_ID');
        rec.project_id      := core.get_grid_data('PROJECT_ID');
        rec.board_id        := core.get_grid_data('BOARD_ID');
        rec.board_name      := core.get_grid_data('BOARD_NAME');
        rec.sequence_id     := core.get_grid_data('SEQUENCE_ID');
        rec.is_simple       := core.get_grid_data('IS_SIMPLE');
        rec.is_default      := core.get_grid_data('IS_DEFAULT');
        rec.is_active       := core.get_grid_data('IS_ACTIVE');
        rec.order#          := core.get_grid_data('ORDER#');
        --
        tsk_tapi.boards(rec, in_action);
        --
        IF in_action = 'D' THEN
            RETURN;     -- exit this procedure
        END IF;

        -- add board to favorites
        DELETE FROM tsk_boards_fav t
        WHERE t.user_id         = core.get_user_id()
            AND t.client_id     = rec.client_id
            AND t.project_id    = rec.project_id
            AND t.board_id      = NVL(core.get_grid_data('BOARD_ID'), rec.board_id);
        --
        IF SQL%ROWCOUNT > 0 THEN
            app.set_success_message('Current board removed from favorites');
        END IF;
        --
        IF core.get_grid_data('IS_FAVORITE') = 'Y' THEN
            INSERT INTO tsk_boards_fav (user_id, client_id, project_id, board_id, swimlane_id, owner_id)
            VALUES (
                core.get_user_id(),
                rec.client_id,
                rec.project_id,
                rec.board_id,
                NULL,
                NULL
            );
            --
            IF SQL%ROWCOUNT > 0 THEN
                app.set_success_message('Current board added to the favorites');
            END IF;
        END IF;
        --
        IF in_action = 'C' THEN
            core.set_item('P0_CLIENT_ID',   rec.client_id);
            core.set_item('P0_PROJECT_ID',  rec.project_id);
            core.set_item('P0_BOARD_ID',    rec.board_id);
        END IF;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_statuses
    AS
        rec                     tsk_statuses%ROWTYPE;
        in_action               CONSTANT CHAR := core.get_grid_action();
    BEGIN
        -- change record in table
        rec.client_id           := core.get_grid_data('CLIENT_ID');
        rec.project_id          := core.get_grid_data('PROJECT_ID');
        rec.status_id           := core.get_grid_data('STATUS_ID');
        rec.status_name         := core.get_grid_data('STATUS_NAME');
        rec.status_group        := core.get_grid_data('STATUS_GROUP');
        rec.col_order#          := core.get_grid_data('COL_ORDER#');
        rec.row_order#          := core.get_grid_data('ROW_ORDER#');
        rec.is_colored          := core.get_grid_data('IS_COLORED');
        rec.is_badge            := core.get_grid_data('IS_BADGE');
        rec.is_default          := core.get_grid_data('IS_DEFAULT');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        --
        tsk_tapi.statuses(rec, in_action);
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_milestones
    AS
        rec                     tsk_milestones%ROWTYPE;
        in_action               CONSTANT CHAR := core.get_grid_action();
    BEGIN
        -- change record in table
        rec.client_id           := core.get_grid_data('CLIENT_ID');
        rec.project_id          := core.get_grid_data('PROJECT_ID');
        rec.milestone_id        := core.get_grid_data('MILESTONE_ID');
        rec.milestone_name      := core.get_grid_data('MILESTONE_NAME');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.order#              := core.get_grid_data('ORDER#');
        --
        tsk_tapi.milestones(rec, in_action);
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_categories
    AS
        rec                     tsk_categories%ROWTYPE;
        in_action               CONSTANT CHAR := core.get_grid_action();
    BEGIN
        -- change record in table
        rec.client_id           := core.get_grid_data('CLIENT_ID');
        rec.project_id          := core.get_grid_data('PROJECT_ID');
        rec.category_id         := core.get_grid_data('CATEGORY_ID');
        rec.category_name       := core.get_grid_data('CATEGORY_NAME');
        rec.category_group      := core.get_grid_data('CATEGORY_GROUP');
        rec.color_bg            := core.get_grid_data('COLOR_BG');
        rec.color_fg            := core.get_grid_data('COLOR_FG');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.is_default          := core.get_grid_data('IS_DEFAULT');
        rec.order#              := core.get_grid_data('ORDER#');
        --
        tsk_tapi.categories(rec, in_action);
        --
        IF in_action = 'D' THEN
            RETURN;     -- exit this procedure
        END IF;
        --
        app.set_success_message('Categories updated');
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_sequences
    AS
        rec                     tsk_sequences%ROWTYPE;
        in_action               CONSTANT CHAR := core.get_grid_action();
    BEGIN
        -- change record in table
        rec.client_id           := core.get_grid_data('CLIENT_ID');
        rec.sequence_id         := core.get_grid_data('SEQUENCE_ID');
        rec.sequence_desc       := core.get_grid_data('SEQUENCE_DESC');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.order#              := core.get_grid_data('ORDER#');
        --
        tsk_tapi.sequences(rec, in_action);
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE copy_statuses
    AS
        rec                     tsk_statuses%ROWTYPE;
        v_affected              PLS_INTEGER := 0;
    BEGIN
        IF core.get_grid_action() = 'D' THEN
            RETURN;
        END IF;

        -- change record in table
        rec.client_id           := core.get_item('P0_CLIENT_ID');
        rec.project_id          := core.get_item('P0_PROJECT_ID');
        rec.status_id           := core.get_grid_data('STATUS_ID');
        rec.status_name         := core.get_grid_data('STATUS_NAME');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.is_default          := core.get_grid_data('IS_DEFAULT');
        rec.is_colored          := core.get_grid_data('IS_COLORED');
        rec.is_badge            := core.get_grid_data('IS_BADGE');
        rec.col_order#          := core.get_grid_data('COL_ORDER#');
        rec.row_order#          := core.get_grid_data('ROW_ORDER#');
        --
        BEGIN
            INSERT INTO tsk_statuses
            VALUES rec;
            --
            v_affected := v_affected + SQL%ROWCOUNT;
            --
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            UPDATE tsk_statuses t
            SET ROW = rec
            WHERE t.status_id       = rec.status_id
                AND t.client_id     = rec.client_id
                AND t.project_id    = rec.project_id;
            --
            v_affected := v_affected + SQL%ROWCOUNT;
        END;
        --
        core.set_item('P0_SUCCESS_MESSAGE', CASE WHEN SQL%ROWCOUNT = 1 THEN v_affected || ' rows affected.' END);
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE copy_milestones
    AS
        rec                     tsk_milestones%ROWTYPE;
        v_affected              PLS_INTEGER := 0;
    BEGIN
        IF core.get_grid_action() = 'D' THEN
            RETURN;
        END IF;

        -- change record in table
        rec.client_id           := core.get_item('P0_CLIENT_ID');
        rec.project_id          := core.get_item('P0_PROJECT_ID');
        rec.milestone_id        := core.get_grid_data('MILESTONE_ID');
        rec.milestone_name      := core.get_grid_data('MILESTONE_NAME');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.order#              := core.get_grid_data('ORDER#');
        --
        BEGIN
            INSERT INTO tsk_milestones
            VALUES rec;
            --
            v_affected := v_affected + SQL%ROWCOUNT;
            --
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            UPDATE tsk_milestones t
            SET ROW = rec
            WHERE t.milestone_id    = rec.milestone_id
                AND t.client_id     = rec.client_id
                AND t.project_id    = rec.project_id;
            --
            v_affected := v_affected + SQL%ROWCOUNT;
        END;
        --
        core.set_item('P0_SUCCESS_MESSAGE', CASE WHEN SQL%ROWCOUNT = 1 THEN v_affected || ' rows affected.' END);
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE copy_categories
    AS
        rec                     tsk_categories%ROWTYPE;
        v_affected              PLS_INTEGER := 0;
    BEGIN
        IF core.get_grid_action() = 'D' THEN
            RETURN;
        END IF;

        -- change record in table
        rec.client_id           := core.get_item('P0_CLIENT_ID');
        rec.project_id          := core.get_item('P0_PROJECT_ID');
        rec.category_id         := core.get_grid_data('CATEGORY_ID');
        rec.category_name       := core.get_grid_data('CATEGORY_NAME');
        rec.category_group      := core.get_grid_data('CATEGORY_GROUP');
        rec.color_bg            := core.get_grid_data('COLOR_BG');
        rec.color_fg            := core.get_grid_data('COLOR_FG');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.is_default          := core.get_grid_data('IS_DEFAULT');
        rec.order#              := core.get_grid_data('ORDER#');
        --
        BEGIN
            INSERT INTO tsk_categories
            VALUES rec;
            --
            v_affected := v_affected + SQL%ROWCOUNT;
            --
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            UPDATE tsk_categories t
            SET ROW = rec
            WHERE t.category_id     = rec.category_id
                AND t.client_id     = rec.client_id
                AND t.project_id    = rec.project_id;
            --
            v_affected := v_affected + SQL%ROWCOUNT;
        END;
        --
        core.set_item('P0_SUCCESS_MESSAGE', CASE WHEN SQL%ROWCOUNT = 1 THEN v_affected || ' rows affected.' END);
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE reorder_milestones
    AS
        in_client_id            CONSTANT tsk_cards.client_id%TYPE   := core.get_item('P0_CLIENT_ID');
        in_project_id           CONSTANT tsk_cards.project_id%TYPE  := core.get_item('P0_PROJECT_ID');
    BEGIN
        FOR s IN (
            SELECT
                t.milestone_id,
                t.client_id,
                t.project_id,
                --
                ROW_NUMBER() OVER (
                    PARTITION BY t.client_id, t.project_id
                    ORDER BY t.order# NULLS LAST, t.milestone_name, t.milestone_id
                ) * 10 AS order#
                --
            FROM tsk_milestones t
            WHERE 1 = 1
                AND t.client_id     = in_client_id
                AND t.project_id    = in_project_id
        ) LOOP
            UPDATE tsk_milestones t
            SET t.order#            = s.order#
            WHERE t.milestone_id    = s.milestone_id
                AND t.client_id     = s.client_id
                AND t.project_id    = s.project_id
                AND (t.order#       != s.order# OR t.order# IS NULL);
        END LOOP;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE reorder_statuses
    AS
        in_client_id            CONSTANT tsk_cards.client_id%TYPE   := core.get_item('P0_CLIENT_ID');
        in_project_id           CONSTANT tsk_cards.project_id%TYPE  := core.get_item('P0_PROJECT_ID');
    BEGIN
        -- fix columns
        FOR s IN (
            SELECT
                t.status_id,
                t.client_id,
                t.project_id,
                c.old_col_order#,
                c.new_col_order#
                --
            FROM tsk_statuses t
            JOIN (
                SELECT
                    t.client_id,
                    t.project_id,
                    t.col_order#    AS old_col_order#,
                    --
                    ROW_NUMBER() OVER (
                        PARTITION BY t.client_id, t.project_id
                        ORDER BY t.col_order#
                    ) AS new_col_order#
                    --
                FROM tsk_statuses t
                WHERE 1 = 1
                    AND t.client_id     = in_client_id
                    AND t.project_id    = in_project_id
                    AND t.col_order#    IS NOT NULL
                GROUP BY
                    t.client_id,
                    t.project_id,
                    t.col_order#
            ) c
                ON c.client_id          = t.client_id
                AND c.project_id        = t.project_id
                AND c.old_col_order#    = t.col_order#
            WHERE 1 = 1
                AND t.client_id         = in_client_id
                AND t.project_id        = in_project_id
                AND t.col_order#        IS NOT NULL
                AND c.old_col_order#    != c.new_col_order#
        ) LOOP
            UPDATE tsk_statuses t
            SET t.col_order#        = s.new_col_order#
            WHERE t.status_id       = s.status_id
                AND t.client_id     = s.client_id
                AND t.project_id    = s.project_id;
        END LOOP;

        -- fix rows
        FOR s IN (
            SELECT
                t.status_id,
                t.client_id,
                t.project_id,
                c.old_row_order#,
                c.new_row_order#
                --
            FROM tsk_statuses t
            JOIN (
                SELECT
                    t.client_id,
                    t.project_id,
                    t.col_order#,
                    t.row_order#    AS old_row_order#,
                    --
                    ROW_NUMBER() OVER (
                        PARTITION BY t.client_id, t.project_id, t.col_order#
                        ORDER BY t.row_order#
                    ) AS new_row_order#
                    --
                FROM tsk_statuses t
                WHERE 1 = 1
                    AND t.client_id     = in_client_id
                    AND t.project_id    = in_project_id
                    AND t.row_order#    IS NOT NULL
                GROUP BY
                    t.client_id,
                    t.project_id,
                    t.col_order#,
                    t.row_order#
            ) c
                ON c.client_id          = t.client_id
                AND c.project_id        = t.project_id
                AND c.col_order#        = t.col_order#
                AND c.old_row_order#    = t.row_order#
            WHERE 1 = 1
                AND t.client_id         = in_client_id
                AND t.project_id        = in_project_id
                AND t.row_order#        IS NOT NULL
                AND c.old_row_order#    != c.new_row_order#
        ) LOOP
            UPDATE tsk_statuses t
            SET t.row_order#        = s.new_row_order#
            WHERE t.status_id       = s.status_id
                AND t.client_id     = s.client_id
                AND t.project_id    = s.project_id;
        END LOOP;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE reorder_categories
    AS
        in_client_id            CONSTANT tsk_cards.client_id%TYPE   := core.get_item('P0_CLIENT_ID');
        in_project_id           CONSTANT tsk_cards.project_id%TYPE  := core.get_item('P0_PROJECT_ID');
    BEGIN
        FOR s IN (
            SELECT
                t.category_id,
                t.client_id,
                t.project_id,
                --
                ROW_NUMBER() OVER (
                    PARTITION BY t.client_id, t.project_id, t.category_group
                    ORDER BY t.order# NULLS LAST, t.category_name, t.category_id
                ) * 10 AS order#
                --
            FROM tsk_categories t
            WHERE 1 = 1
                AND t.client_id     = in_client_id
                AND t.project_id    = in_project_id
        ) LOOP
            UPDATE tsk_categories t
            SET t.order#            = s.order#
            WHERE t.category_id     = s.category_id
                AND t.client_id     = s.client_id
                AND t.project_id    = s.project_id
                AND (t.order#       != s.order# OR t.order# IS NULL);
        END LOOP;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE reorder_sequences
    AS
        in_client_id            CONSTANT tsk_cards.client_id%TYPE   := core.get_item('P0_CLIENT_ID');
        in_project_id           CONSTANT tsk_cards.project_id%TYPE  := core.get_item('P0_PROJECT_ID');
    BEGIN
        FOR s IN (
            SELECT
                t.sequence_id,
                t.client_id,
                --
                ROW_NUMBER() OVER (
                    PARTITION BY t.client_id
                    ORDER BY t.order# NULLS LAST, t.sequence_id
                ) * 10 AS order#
                --
            FROM tsk_sequences t
            WHERE 1 = 1
                AND t.client_id     = in_client_id
        ) LOOP
            UPDATE tsk_sequences t
            SET t.order#            = s.order#
            WHERE t.sequence_id     = s.sequence_id
                AND t.client_id     = s.client_id
                AND (t.order#       != s.order# OR t.order# IS NULL);
        END LOOP;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE reorder_boards
    AS
        in_client_id            CONSTANT tsk_cards.client_id%TYPE   := core.get_item('P0_CLIENT_ID');
        in_project_id           CONSTANT tsk_cards.project_id%TYPE  := core.get_item('P0_PROJECT_ID');
    BEGIN
        FOR s IN (
            SELECT
                t.board_id,
                t.client_id,
                t.project_id,
                --
                ROW_NUMBER() OVER (
                    PARTITION BY t.client_id, t.project_id
                    ORDER BY t.order# NULLS LAST, t.board_id
                ) * 10 AS order#
                --
            FROM tsk_boards t
            WHERE 1 = 1
                AND t.client_id     = in_client_id
                AND t.project_id    = in_project_id
        ) LOOP
            UPDATE tsk_boards t
            SET t.order#            = s.order#
            WHERE t.board_id        = s.board_id
                AND t.client_id     = s.client_id
                AND t.project_id    = s.project_id
                AND (t.order#       != s.order# OR t.order# IS NULL);
        END LOOP;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;

END;
/

