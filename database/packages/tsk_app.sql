CREATE OR REPLACE PACKAGE BODY tsk_app AS

    PROCEDURE init_defaults
    AS
    BEGIN
        tsk_app.set_context (
            in_client_id        => tsk_app.get_client_id(),
            in_project_id       => tsk_app.get_project_id(),
            in_board_id         => tsk_app.get_board_id(),
            in_swimlane_id      => tsk_app.get_swimlane_id(),
            in_status_id        => tsk_app.get_status_id(),
            in_category_id      => tsk_app.get_category_id(),
            in_owner_id         => tsk_app.get_owner_id()
        );
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
        in_client_id        tsk_clients.client_id%TYPE := NULL
    )
    RETURN tsk_clients.client_name%TYPE
    AS
        out_name            tsk_clients.client_name%TYPE;
    BEGIN
        SELECT t.client_name INTO out_name
        FROM tsk_clients t
        WHERE t.client_id   = COALESCE(in_client_id, tsk_app.get_client_id());
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
        in_project_id       tsk_projects.project_id%TYPE := NULL
    )
    RETURN tsk_projects.project_name%TYPE
    AS
        out_name            tsk_projects.project_name%TYPE;
    BEGIN
        SELECT t.project_name INTO out_name
        FROM tsk_projects t
        WHERE t.client_id       = tsk_app.get_client_id()
            AND t.project_id    = COALESCE(in_project_id, tsk_app.get_project_id());
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
        in_board_id         tsk_boards.board_id%TYPE := NULL
    )
    RETURN tsk_boards.board_name%TYPE
    AS
        out_name            tsk_boards.board_name%TYPE;
    BEGIN
        SELECT t.board_name INTO out_name
        FROM tsk_boards t
        WHERE t.client_id       = tsk_app.get_client_id()
            AND t.project_id    = tsk_app.get_project_id()
            AND t.board_id      = COALESCE(in_board_id, tsk_app.get_board_id());
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



    FUNCTION get_swimlane_name (
        in_swimlane_id      tsk_swimlanes.swimlane_id%TYPE := NULL
    )
    RETURN tsk_swimlanes.swimlane_name%TYPE
    AS
        out_name            tsk_swimlanes.swimlane_name%TYPE;
    BEGIN
        SELECT t.swimlane_name INTO out_name
        FROM tsk_swimlanes t
        WHERE t.client_id       = tsk_app.get_client_id()
            AND t.project_id    = tsk_app.get_project_id()
            AND t.swimlane_id   = COALESCE(in_swimlane_id, tsk_app.get_swimlane_id());
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_status_id
    RETURN tsk_statuses.status_id%TYPE
    AS
    BEGIN
        RETURN core.get_item('P0_STATUS_ID');
    END;



    FUNCTION get_status_name (
        in_status_id        tsk_statuses.status_id%TYPE := NULL
    )
    RETURN tsk_statuses.status_name%TYPE
    AS
        out_name            tsk_statuses.status_name%TYPE;
    BEGIN
        SELECT t.status_name INTO out_name
        FROM tsk_statuses t
        WHERE t.client_id       = tsk_app.get_client_id()
            AND t.project_id    = tsk_app.get_project_id()
            AND t.status_id     = COALESCE(in_status_id, tsk_app.get_status_id());
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_category_id
    RETURN tsk_categories.category_id%TYPE
    AS
    BEGIN
        RETURN core.get_item('P0_CATEGORY_ID');
    END;



    FUNCTION get_category_name (
        in_category_id      tsk_categories.category_id%TYPE := NULL
    )
    RETURN tsk_categories.category_name%TYPE
    AS
        out_name            tsk_categories.category_name%TYPE;
    BEGIN
        SELECT t.category_name INTO out_name
        FROM tsk_categories t
        WHERE t.client_id       = tsk_app.get_client_id()
            AND t.project_id    = tsk_app.get_project_id()
            AND t.category_id   = COALESCE(in_category_id, tsk_app.get_category_id());
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_owner_id
    RETURN tsk_cards.owner_id%TYPE
    AS
    BEGIN
        RETURN core.get_item('P0_OWNER_ID');
    END;



    FUNCTION get_owner_name (
        in_owner_id         tsk_cards.owner_id%TYPE := NULL
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN COALESCE(in_owner_id, core.get_item('P0_OWNER_ID'));
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
        in_swimlane_id      tsk_recent.swimlane_id%TYPE     := NULL,
        in_status_id        tsk_recent.status_id%TYPE       := NULL,
        in_category_id      tsk_recent.category_id%TYPE     := NULL,
        in_owner_id         tsk_recent.owner_id%TYPE        := NULL
    )
    AS
        rec                 tsk_recent%ROWTYPE;
    BEGIN
        rec.user_id         := core.get_user_id();
        rec.client_id       := in_client_id;
        rec.project_id      := in_project_id;
        rec.board_id        := in_board_id;
        rec.swimlane_id     := in_swimlane_id;
        rec.status_id       := in_status_id;
        rec.category_id     := in_category_id;
        rec.owner_id        := in_owner_id;

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

        -- save current selection
        tsk_tapi.save_recent(rec);

        -- set verified values
        core.set_item('P0_CLIENT_ID',       rec.client_id);
        core.set_item('P0_CLIENT_NAME',     tsk_app.get_client_name(rec.client_id));
        core.set_item('P0_PROJECT_ID',      rec.project_id);
        core.set_item('P0_PROJECT_NAME',    tsk_app.get_project_name(rec.project_id));
        core.set_item('P0_BOARD_ID',        rec.board_id);
        core.set_item('P0_BOARD_NAME',      tsk_app.get_board_name(rec.board_id));
        core.set_item('P0_SWIMLANE_ID',     rec.swimlane_id);
        core.set_item('P0_SWIMLANE_NAME',   tsk_app.get_swimlane_name(rec.swimlane_id));
        core.set_item('P0_STATUS_ID',       rec.status_id);
        core.set_item('P0_STATUS_NAME',     tsk_app.get_status_name(rec.status_id));
        core.set_item('P0_CATEGORY_ID',     rec.category_id);
        core.set_item('P0_CATEGORY_NAME',   tsk_app.get_category_name(rec.category_id));
        core.set_item('P0_OWNER_ID',        rec.owner_id);
        core.set_item('P0_OWNER_NAME',      tsk_app.get_owner_name(rec.owner_id));
        --
        core.set_item('P0_CLIENT_FILTER',       '<br /><span class="CURRENT">' || core.get_item('P0_CLIENT_NAME')   || '</span>');
        core.set_item('P0_PROJECT_FILTER',      '<br /><span class="CURRENT">' || core.get_item('P0_PROJECT_NAME')  || '</span>');
        core.set_item('P0_BOARD_FILTER',        '<br /><span class="CURRENT">' || core.get_item('P0_BOARD_NAME')    || '</span>');
        core.set_item('P0_SWIMLANE_FILTER',     '<br /><span class="CURRENT">' || core.get_item('P0_SWIMLANE_NAME') || '</span>');
        core.set_item('P0_STATUS_FILTER',       '<br /><span class="CURRENT">' || core.get_item('P0_STATUS_NAME')   || '</span>');
        core.set_item('P0_CATEGORY_FILTER',     '<br /><span class="CURRENT">' || core.get_item('P0_CATEGORY_NAME') || '</span>');
        core.set_item('P0_OWNER_FILTER',        '<br /><span class="CURRENT">' || core.get_item('P0_OWNER_NAME')    || '</span>');

        -- temp message
        IF core.get_page_id() = 100 AND rec.client_id IS NOT NULL THEN
            --app.ajax_message('Context: Client=' || rec.client_id || ' | Project=' || rec.project_id || ' | Board=' || rec.board_id);
            NULL;
        END IF;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_card_next_sequence (
        in_sequence_id      tsk_sequences.sequence_id%TYPE,
        in_client_id        tsk_sequences.client_id%TYPE        := NULL
    )
    RETURN tsk_cards.card_number%TYPE
    AS
        v_max               tsk_cards.card_number%TYPE;
        v_value             tsk_cards.card_number%TYPE;
    BEGIN
        SELECT
            MAX(t.card_number),
            REGEXP_SUBSTR(REPLACE(MAX(t.card_number), in_sequence_id, ''), '\d+$')
        INTO v_max, v_value
        FROM tsk_cards t
        WHERE t.client_id       = COALESCE(in_client_id, tsk_app.get_client_id())
            AND t.card_number   LIKE in_sequence_id || '%';
        --
        IF v_max IS NULL AND v_value IS NULL THEN   -- first value
            RETURN in_sequence_id || '-001';
        END IF;
        --
        RETURN REPLACE(v_max, v_value, LPAD(TO_NUMBER(v_value) + 1, LENGTH(v_value), '0'));
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_card_sequence (
        in_card_number      tsk_cards.card_number%TYPE,
        in_client_id        tsk_cards.client_id%TYPE        := NULL
    )
    RETURN tsk_sequences.sequence_id%TYPE
    AS
        v_sequence_id       tsk_sequences.sequence_id%TYPE;
    BEGIN
        SELECT MAX(t.sequence_id)
        INTO v_sequence_id
        FROM tsk_sequences t
        WHERE t.client_id   = COALESCE(in_client_id, tsk_app.get_client_id())
            AND REGEXP_REPLACE(in_card_number, '\d+$', '') LIKE t.sequence_id || '%';
        --
        RETURN v_sequence_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;

END;
/

