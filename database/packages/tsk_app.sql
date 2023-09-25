CREATE OR REPLACE PACKAGE BODY tsk_app AS

    PROCEDURE init_defaults
    AS
    BEGIN
        tsk_app.set_context (
            in_client_id        => tsk_app.get_client_id(),
            in_project_id       => tsk_app.get_project_id(),
            in_board_id         => tsk_app.get_board_id(),
            in_swimlanes        => NULL,
            in_owners           => NULL
        );
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;




    PROCEDURE init_defaults_p100
    AS
    BEGIN
        core.set_item('P100_HEADER',
            core.get_item('P0_CLIENT_NAME')     || ' &' || 'ndash; ' ||
            core.get_item('P0_PROJECT_NAME')    || ' &' || 'ndash; ' ||
            core.get_item('P0_BOARD_NAME')
        );
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;




    FUNCTION get_client_id
    RETURN tsk_clients.client_id%TYPE
    AS
    BEGIN
        RETURN core.get_item('P0_CLIENT_ID');
    END;



    FUNCTION get_client_name (
        in_client_id        tsk_clients.client_id%TYPE
    )
    RETURN tsk_clients.client_name%TYPE
    AS
        out_name            tsk_clients.client_name%TYPE;
    BEGIN
        SELECT t.client_name INTO out_name
        FROM tsk_clients t
        WHERE t.client_id   = in_client_id;
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_project_id
    RETURN tsk_projects.project_id%TYPE
    AS
    BEGIN
        RETURN core.get_item('P0_PROJECT_ID');
    END;



    FUNCTION get_project_name (
        in_project_id       tsk_projects.project_id%TYPE
    )
    RETURN tsk_projects.project_name%TYPE
    AS
        out_name            tsk_projects.project_name%TYPE;
    BEGIN
        SELECT t.project_name INTO out_name
        FROM tsk_projects t
        WHERE t.project_id  = in_project_id;
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_board_id
    RETURN tsk_boards.board_id%TYPE
    AS
    BEGIN
        RETURN core.get_number_item('P0_BOARD_ID');
    END;



    FUNCTION get_board_name (
        in_board_id         tsk_boards.board_id%TYPE
    )
    RETURN tsk_boards.board_name%TYPE
    AS
        out_name            tsk_boards.board_name%TYPE;
    BEGIN
        SELECT t.board_name INTO out_name
        FROM tsk_boards t
        WHERE t.board_id    = in_board_id;
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_swimlane_id
    RETURN tsk_swimlanes.swimlane_id%TYPE
    AS
    BEGIN
        RETURN core.get_item('P0_SWIMLANE_ID');
    END;



    FUNCTION get_owner_id
    RETURN tsk_tasks.owner_id%TYPE
    AS
    BEGIN
        RETURN core.get_item('P0_OWNER_ID');
    END;



    PROCEDURE find_project (
        io_client_id        IN OUT NOCOPY tsk_recent.client_id%TYPE,
        io_project_id       IN OUT NOCOPY tsk_recent.project_id%TYPE,
        io_board_id         IN OUT NOCOPY tsk_recent.board_id%TYPE
    )
    AS
        in_user_id          CONSTANT app_users.user_id%TYPE := core.get_user_id();
    BEGIN
        -- get requested project
        SELECT MIN(t.project_id) INTO io_project_id
        FROM tsk_available_projects_v t
        WHERE t.client_id       = io_client_id
            AND t.project_id    = io_project_id;
        --
        IF io_project_id IS NOT NULL THEN
            RETURN;
        END IF;

        -- get recent project
        SELECT MIN(t.project_id) KEEP (DENSE_RANK FIRST ORDER BY t.updated_at DESC)
        INTO io_project_id
        FROM tsk_recent t
        JOIN tsk_available_projects_v a
            ON a.client_id      = t.client_id
            AND a.project_id    = t.project_id
        WHERE t.client_id       = io_client_id;
        --
        IF io_project_id IS NOT NULL THEN
            RETURN;
        END IF;

        -- get default (or the most recent) project
        SELECT MIN(t.project_id) KEEP (DENSE_RANK FIRST ORDER BY t.is_default NULLS LAST, t.project_id DESC)
        INTO io_project_id
        FROM tsk_available_projects_v t
        WHERE t.client_id       = io_client_id;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE find_board (
        io_client_id        IN OUT NOCOPY tsk_recent.client_id%TYPE,
        io_project_id       IN OUT NOCOPY tsk_recent.project_id%TYPE,
        io_board_id         IN OUT NOCOPY tsk_recent.board_id%TYPE
    )
    AS
        in_user_id          CONSTANT app_users.user_id%TYPE := core.get_user_id();
    BEGIN
        -- get requested board
        SELECT MIN(t.board_id) INTO io_board_id
        FROM tsk_available_boards_v t
        WHERE t.client_id       = io_client_id
            AND t.project_id    = io_project_id
            AND t.board_id      = io_board_id;
        --
        IF io_board_id IS NOT NULL THEN
            RETURN;
        END IF;

        -- get recent board
        SELECT MIN(t.board_id) INTO io_board_id
        FROM tsk_recent t
        JOIN tsk_available_boards_v a
            ON a.client_id      = t.client_id
            AND a.project_id    = t.project_id
            AND a.board_id      = t.board_id
        WHERE t.client_id       = io_client_id
            AND t.project_id    = io_project_id;
        --
        IF io_board_id IS NOT NULL THEN
            RETURN;
        END IF;

        -- get default (or the most recent) board
        SELECT MIN(t.board_id) KEEP (DENSE_RANK FIRST ORDER BY t.is_default NULLS LAST, t.board_id DESC)
        INTO io_board_id
        FROM tsk_available_boards_v t
        WHERE t.client_id       = io_client_id
            AND t.project_id    = io_project_id;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE set_context (
        in_client_id        tsk_recent.client_id%TYPE       := NULL,
        in_project_id       tsk_recent.project_id%TYPE      := NULL,
        in_board_id         tsk_recent.board_id%TYPE        := NULL,
        in_swimlanes        tsk_recent.swimlanes%TYPE       := NULL,
        in_owners           tsk_recent.owners%TYPE          := NULL
    )
    AS
        rec                 tsk_recent%ROWTYPE;
    BEGIN
        rec.client_id       := in_client_id;
        rec.project_id      := in_project_id;
        rec.board_id        := in_board_id;
        rec.swimlanes       := in_swimlanes;
        rec.owners          := in_owners;

        -- possible actions
        -- switch client    = verify client, get recent project
        -- switch project   = verify project, get recent board, swimlanes, owners
        -- switch board     = verify board
        --
        IF (rec.project_id IS NOT NULL OR rec.client_id IS NOT NULL) THEN
            tsk_app.find_project (
                io_client_id        => rec.client_id,
                io_project_id       => rec.project_id,
                io_board_id         => rec.board_id
            );
            tsk_app.find_board (
                io_client_id        => rec.client_id,
                io_project_id       => rec.project_id,
                io_board_id         => rec.board_id
            );
        END IF;
        --
        IF rec.board_id IS NOT NULL THEN
            tsk_app.find_board (
                io_client_id        => rec.client_id,
                io_project_id       => rec.project_id,
                io_board_id         => rec.board_id
            );
        END IF;

        -- set verified values
        -- @TODO: with menu links remove p$
        core.set_item('$CLIENT_ID',     rec.client_id);     core.set_item('P0_CLIENT_ID',     rec.client_id);
        core.set_item('$PROJECT_ID',    rec.project_id);    core.set_item('P0_PROJECT_ID',    rec.project_id);
        core.set_item('$BOARD_ID',      rec.board_id);      core.set_item('P0_BOARD_ID',      rec.board_id);
        core.set_item('$SWIMLANES',     rec.swimlanes);     core.set_item('P0_SWIMLANES',     rec.swimlanes);
        core.set_item('$OWNERS',        rec.owners);        core.set_item('P0_OWNERS',        rec.owners);
        --
        FOR c IN (
            SELECT
                p.client_name,
                p.project_name,
                b.board_name
            FROM tsk_available_projects_v p
            LEFT JOIN tsk_available_boards_v b
                ON b.client_id      = p.client_id
                AND b.project_id    = p.project_id
                AND b.board_id      = rec.board_id
            WHERE p.client_id       = rec.client_id
                AND p.project_id    = rec.project_id
        ) LOOP
            core.set_item('P0_CLIENT_NAME',     c.client_name);
            core.set_item('P0_PROJECT_NAME',    c.project_name);
            core.set_item('P0_BOARD_NAME',      c.board_name);
        END LOOP;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_task_link (
        in_task_id          tsk_tasks.task_id%TYPE,
        in_external         CHAR                        := NULL
    )
    RETURN VARCHAR2
    AS
    BEGIN
        IF in_external IS NOT NULL THEN
            RETURN
                REGEXP_REPLACE(APEX_MAIL.GET_INSTANCE_URL, '/ords/.*$', '') ||
                APEX_PAGE.GET_URL (
                    p_application       => core.get_app_id(),
                    p_session           => core.get_session_id(),
                    p_page              => 100,
                    p_clear_cache       => 100,
                    p_items             => 'P100_TASK_ID',
                    p_values            => in_task_id,
                    p_plain_url         => TRUE
                );
        END IF;
        --
        FOR c IN (
            SELECT
                t.task_id,
                t.client_id,
                t.project_id,
                t.board_id
            FROM tsk_tasks t
            WHERE t.task_id = in_task_id
        ) LOOP
            RETURN APEX_PAGE.GET_URL (
                p_page              => 105,
                p_clear_cache       => 105,
                p_items             => 'P105_TASK_ID',
                p_values            => c.task_id
            );
        END LOOP;
        --
        RETURN NULL;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE set_user_preferences (
        in_user_id          app_users.user_id%TYPE,
        in_client_id        tsk_clients.client_id%TYPE,
        in_project_id       tsk_projects.project_id%TYPE,
        in_board_id         tsk_boards.board_id%TYPE,
        in_swimlane_id      tsk_swimlanes.swimlane_id%TYPE      := NULL
    )
    AS
        rec                 tsk_tasks%ROWTYPE;  -- used just for validations
    BEGIN
        rec.client_id       := in_client_id;
        rec.project_id      := in_project_id;
        rec.board_id        := in_board_id;
        rec.swimlane_id     := in_swimlane_id;
        --
        tsk_app.validate_user_preferences (
            io_user_id          => rec.updated_by,
            io_client_id        => rec.client_id,
            io_project_id       => rec.project_id,
            io_board_id         => rec.board_id,
            io_swimlane_id      => rec.swimlane_id
        );

        -- store values in user preferences for this and next session
        APEX_UTIL.SET_PREFERENCE('CLIENT_ID',   rec.client_id);
        APEX_UTIL.SET_PREFERENCE('PROJECT_ID',  rec.project_id);
        APEX_UTIL.SET_PREFERENCE('BOARD_ID',    rec.board_id);
        --
        IF in_swimlane_id IS NOT NULL THEN
            APEX_UTIL.SET_PREFERENCE('SWIMLANE_ID', rec.swimlane_id);
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE validate_user_preferences (
        io_user_id          IN OUT NOCOPY   App_users.user_id%TYPE,
        io_client_id        IN OUT NOCOPY   tsk_clients.client_id%TYPE,
        io_project_id       IN OUT NOCOPY   tsk_projects.project_id%TYPE,
        io_board_id         IN OUT NOCOPY   tsk_boards.board_id%TYPE,
        io_swimlane_id      IN OUT NOCOPY   tsk_swimlanes.swimlane_id%TYPE
    )
    AS
    BEGIN
        io_user_id  := COALESCE(io_user_id, core.get_user_id());

        -- check if you can access requested board/project/client
        --
        -- @TODO:
        --      TSK_AUTH_AVAILABLE_BOARDS_V, TSK_AUTH_AVAILABLE_CLIENTS_V, TSK_AUTH_AVAILABLE_PROJECTS_V
        --
        NULL;

        -- verify board and swimlane, override project and client
        BEGIN
            SELECT
                t.client_id,
                t.project_id,
                t.board_id
            INTO
                io_client_id,
                io_project_id,
                io_board_id
            FROM tsk_boards t
            WHERE t.board_id        = io_board_id
                AND io_board_id     IS NOT NULL;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- verify at least project, override client
            BEGIN
                SELECT
                    t.client_id,
                    t.project_id
                INTO
                    io_client_id,
                    io_project_id
                FROM tsk_projects t
                WHERE t.project_id      = io_project_id
                    AND io_project_id   IS NOT NULL;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- verify at least client
                BEGIN
                    SELECT t.client_id INTO io_client_id
                    FROM tsk_clients t
                    WHERE t.client_id       = io_client_id
                        AND io_client_id    IS NOT NULL;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
                END;
            END;
        END;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE init_projects
    AS
    BEGIN
        -- save selected client as current
        IF core.get_number_item('CLIENT_ID') IS NOT NULL THEN
            tsk_app.set_user_preferences (
                in_user_id          => core.get_user_id(),
                in_client_id        => core.get_number_item('CLIENT_ID'),
                in_project_id       => NULL,
                in_board_id         => NULL
            );
        END IF;
    END;

END;
/

