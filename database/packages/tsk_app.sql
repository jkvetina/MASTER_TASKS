CREATE OR REPLACE PACKAGE BODY tsk_app AS

    FUNCTION get_client_id
    RETURN tsk_clients.client_id%TYPE
    AS
    BEGIN
        RETURN APEX_UTIL.GET_PREFERENCE('CLIENT_ID');
    END;



    FUNCTION get_project_id
    RETURN tsk_projects.project_id%TYPE
    AS
    BEGIN
        RETURN APEX_UTIL.GET_PREFERENCE('PROJECT_ID');
    END;



    FUNCTION get_board_id
    RETURN tsk_boards.board_id%TYPE
    AS
    BEGIN
        RETURN TO_NUMBER(APEX_UTIL.GET_PREFERENCE('BOARD_ID'));
    END;



    FUNCTION get_swimlane_id
    RETURN tsk_swimlanes.swimlane_id%TYPE
    AS
    BEGIN
        RETURN APEX_UTIL.GET_PREFERENCE('SWIMLANE_ID');
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

