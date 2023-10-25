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
        tsk_tapi.clients (rec,
            in_action       => in_action,
            in_client_id    => core.get_grid_data('OLD_CLIENT_ID')
        );
        --
        IF in_action = 'D' THEN
            COMMIT;     -- commit to catch possible error here, because all foreign keys are deferred
            RETURN;     -- exit this procedure
        END IF;

        -- update primary key back to APEX grid for proper row refresh
        core.set_grid_data('OLD_CLIENT_ID',     rec.client_id);
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
        rec.is_active       := core.get_grid_data('IS_ACTIVE');
        rec.is_default      := core.get_grid_data('IS_DEFAULT');
        --
        tsk_tapi.projects (rec,
            in_action           => in_action,
            in_client_id        => NVL(core.get_grid_data('OLD_CLIENT_ID'), rec.client_id),
            in_project_id       => NVL(core.get_grid_data('OLD_PROJECT_ID'), rec.project_id)
        );
        --
        IF in_action = 'D' THEN
            COMMIT;     -- commit to catch possible error here, because all foreign keys are deferred
            RETURN;     -- exit this procedure
        END IF;

        -- update primary key back to APEX grid for proper row refresh
        core.set_grid_data('OLD_CLIENT_ID',         rec.client_id);
        core.set_grid_data('OLD_PROJECT_ID',        rec.project_id);
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
        rec.is_active       := core.get_grid_data('IS_ACTIVE');
        rec.is_default      := core.get_grid_data('IS_DEFAULT');
        rec.order#          := core.get_grid_data('ORDER#');
        --
        tsk_tapi.boards (rec,
            in_action           => in_action,
            in_board_id         => NVL(core.get_grid_data('OLD_BOARD_ID'), rec.board_id)
        );
        --
        IF in_action = 'D' THEN
            RETURN;     -- exit this procedure
        END IF;

        -- update primary key back to APEX grid for proper row refresh
        core.set_grid_data('OLD_BOARD_ID',          rec.board_id);

        -- add board to favorites
        DELETE FROM tsk_boards_fav t
        WHERE t.user_id         = core.get_user_id()
            AND t.client_id     = rec.client_id
            AND t.project_id    = rec.project_id
            AND t.board_id      = NVL(core.get_grid_data('OLD_BOARD_ID'), rec.board_id);
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
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.is_default          := core.get_grid_data('IS_DEFAULT');
        rec.is_colored          := core.get_grid_data('IS_COLORED');
        rec.is_badge            := core.get_grid_data('IS_BADGE');
        rec.order#              := core.get_grid_data('ORDER#');
        --
        tsk_tapi.statuses (rec,
            in_action               => in_action,
            in_client_id            => NVL(core.get_grid_data('OLD_CLIENT_ID'), rec.client_id),
            in_project_id           => NVL(core.get_grid_data('OLD_PROJECT_ID'), rec.project_id),
            in_status_id            => NVL(core.get_grid_data('OLD_STATUS_ID'), rec.status_id)
        );
        --
        IF in_action = 'D' THEN
            RETURN;     -- exit this procedure
        END IF;

        -- update primary key back to APEX grid for proper row refresh
        core.set_grid_data('OLD_CLIENT_ID',         rec.client_id);
        core.set_grid_data('OLD_PROJECT_ID',        rec.project_id);
        core.set_grid_data('OLD_STATUS_ID',         rec.status_id);
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_swimlanes
    AS
        rec                     tsk_swimlanes%ROWTYPE;
        in_action               CONSTANT CHAR := core.get_grid_action();
    BEGIN
        -- change record in table
        rec.client_id           := core.get_grid_data('CLIENT_ID');
        rec.project_id          := core.get_grid_data('PROJECT_ID');
        rec.swimlane_id         := core.get_grid_data('SWIMLANE_ID');
        rec.swimlane_name       := core.get_grid_data('SWIMLANE_NAME');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.order#              := core.get_grid_data('ORDER#');
        --
        tsk_tapi.swimlanes (rec,
            in_action               => in_action,
            in_client_id            => NVL(core.get_grid_data('OLD_CLIENT_ID'), rec.client_id),
            in_project_id           => NVL(core.get_grid_data('OLD_PROJECT_ID'), rec.project_id),
            in_swimlane_id          => NVL(core.get_grid_data('OLD_SWIMLANE_ID'), rec.swimlane_id)
        );
        --
        IF in_action = 'D' THEN
            RETURN;     -- exit this procedure
        END IF;

        -- update primary key back to APEX grid for proper row refresh
        core.set_grid_data('OLD_CLIENT_ID',         rec.client_id);
        core.set_grid_data('OLD_PROJECT_ID',        rec.project_id);
        core.set_grid_data('OLD_SWIMLANE_ID',       rec.swimlane_id);
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
        tsk_tapi.categories (rec,
            in_action               => in_action,
            in_client_id            => NVL(core.get_grid_data('OLD_CLIENT_ID'), rec.client_id),
            in_project_id           => NVL(core.get_grid_data('OLD_PROJECT_ID'), rec.project_id),
            in_category_id          => NVL(core.get_grid_data('OLD_CATEGORY_ID'), rec.category_id)
        );
        --
        IF in_action = 'D' THEN
            RETURN;     -- exit this procedure
        END IF;

        -- update primary key back to APEX grid for proper row refresh
        core.set_grid_data('OLD_CLIENT_ID',         rec.client_id);
        core.set_grid_data('OLD_PROJECT_ID',        rec.project_id);
        core.set_grid_data('OLD_CATEGORY_ID',       rec.category_id);
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
        tsk_tapi.sequences (rec,
            in_action               => in_action,
            in_client_id            => NVL(core.get_grid_data('OLD_CLIENT_ID'), rec.client_id),
            in_sequence_id          => NVL(core.get_grid_data('OLD_SEQUENCE_ID'), rec.sequence_id)
        );
        --
        IF in_action = 'D' THEN
            RETURN;     -- exit this procedure
        END IF;

        -- update primary key back to APEX grid for proper row refresh
        core.set_grid_data('OLD_CLIENT_ID',         rec.client_id);
        core.set_grid_data('OLD_SEQUENCE_ID',       rec.sequence_id);
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE reorder_statuses
    AS
        in_client_id            CONSTANT tsk_cards.client_id%TYPE   := tsk_app.get_client_id();
        in_project_id           CONSTANT tsk_cards.project_id%TYPE  := tsk_app.get_project_id();
    BEGIN
        FOR s IN (
            SELECT
                t.status_id,
                t.client_id,
                t.project_id,
                --
                ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id ORDER BY t.order# NULLS LAST, t.status_name, t.status_id) * 10 AS order#
            FROM tsk_statuses t
            WHERE 1 = 1
                AND (t.client_id    = in_client_id  OR in_client_id  IS NULL)
                AND (t.project_id   = in_project_id OR in_project_id IS NULL)
        ) LOOP
            UPDATE tsk_statuses t
            SET t.order#            = s.order#
            WHERE t.status_id       = s.status_id
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



    PROCEDURE copy_statuses
    AS
        rec                     tsk_statuses%ROWTYPE;
        v_affected              PLS_INTEGER := 0;
    BEGIN
        IF core.get_grid_action() = 'D' THEN
            RETURN;
        END IF;

        -- change record in table
        rec.client_id           := tsk_app.get_client_id();
        rec.project_id          := tsk_app.get_project_id();
        rec.status_id           := core.get_grid_data('STATUS_ID');
        rec.status_name         := core.get_grid_data('STATUS_NAME');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.is_default          := core.get_grid_data('IS_DEFAULT');
        rec.is_colored          := core.get_grid_data('IS_COLORED');
        rec.is_badge            := core.get_grid_data('IS_BADGE');
        rec.order#              := core.get_grid_data('ORDER#');
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



    PROCEDURE reorder_swimlanes
    AS
        in_client_id            CONSTANT tsk_cards.client_id%TYPE   := tsk_app.get_client_id();
        in_project_id           CONSTANT tsk_cards.project_id%TYPE  := tsk_app.get_project_id();
    BEGIN
        FOR s IN (
            SELECT
                t.swimlane_id,
                t.client_id,
                t.project_id,
                --
                ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id ORDER BY t.order# NULLS LAST, t.swimlane_name, t.swimlane_id) * 10 AS order#
            FROM tsk_swimlanes t
            WHERE 1 = 1
                AND (t.client_id    = in_client_id  OR in_client_id  IS NULL)
                AND (t.project_id   = in_project_id OR in_project_id IS NULL)
        ) LOOP
            UPDATE tsk_swimlanes t
            SET t.order#            = s.order#
            WHERE t.swimlane_id     = s.swimlane_id
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



    PROCEDURE copy_swimlanes
    AS
        rec                     tsk_swimlanes%ROWTYPE;
        v_affected              PLS_INTEGER := 0;
    BEGIN
        IF core.get_grid_action() = 'D' THEN
            RETURN;
        END IF;

        -- change record in table
        rec.client_id           := tsk_app.get_client_id();
        rec.project_id          := tsk_app.get_project_id();
        rec.swimlane_id         := core.get_grid_data('SWIMLANE_ID');
        rec.swimlane_name       := core.get_grid_data('SWIMLANE_NAME');
        rec.is_active           := core.get_grid_data('IS_ACTIVE');
        rec.order#              := core.get_grid_data('ORDER#');
        --
        BEGIN
            INSERT INTO tsk_swimlanes
            VALUES rec;
            --
            v_affected := v_affected + SQL%ROWCOUNT;
            --
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            UPDATE tsk_swimlanes t
            SET ROW = rec
            WHERE t.swimlane_id     = rec.swimlane_id
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



    PROCEDURE reorder_categories
    AS
        in_client_id            CONSTANT tsk_cards.client_id%TYPE   := tsk_app.get_client_id();
        in_project_id           CONSTANT tsk_cards.project_id%TYPE  := tsk_app.get_project_id();
    BEGIN
        FOR s IN (
            SELECT
                t.category_id,
                t.client_id,
                t.project_id,
                --
                ROW_NUMBER() OVER (PARTITION BY t.client_id, t.project_id, t.category_group ORDER BY t.order# NULLS LAST, t.category_name, t.category_id) * 10 AS order#
            FROM tsk_categories t
            WHERE 1 = 1
                AND (t.client_id    = in_client_id  OR in_client_id  IS NULL)
                AND (t.project_id   = in_project_id OR in_project_id IS NULL)
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



    PROCEDURE copy_categories
    AS
        rec                     tsk_categories%ROWTYPE;
        v_affected              PLS_INTEGER := 0;
    BEGIN
        IF core.get_grid_action() = 'D' THEN
            RETURN;
        END IF;

        -- change record in table
        rec.client_id           := tsk_app.get_client_id();
        rec.project_id          := tsk_app.get_project_id();
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

END;
/

