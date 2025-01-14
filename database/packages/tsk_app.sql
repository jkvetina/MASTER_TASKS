CREATE OR REPLACE PACKAGE BODY tsk_app AS

    PROCEDURE init_defaults
    AS
        v_old_client_id         tsk_clients.client_id%TYPE;
        v_old_project_id        tsk_projects.project_id%TYPE;
        v_old_board_id          tsk_boards.board_id%TYPE;
        --
        v_new_client_id         tsk_clients.client_id%TYPE;
        v_new_project_id        tsk_projects.project_id%TYPE;
        v_new_board_id          tsk_boards.board_id%TYPE;
    BEGIN
        v_old_client_id         := core.get_number_item('P0_CLIENT_ID');
        v_old_project_id        := core.get_number_item('P0_PROJECT_ID');
        v_old_board_id          := core.get_number_item('P0_BOARD_ID');
        --
        v_new_client_id         := NVL(core.get_item('$ACTIVE_CLIENT'),     v_old_client_id);
        v_new_project_id        := NVL(core.get_item('$ACTIVE_PROJECT'),    v_old_project_id);
        v_new_board_id          := NVL(core.get_item('$ACTIVE_BOARD'),      v_old_board_id);
        --
        IF v_new_client_id IS NOT NULL AND v_new_client_id != v_old_client_id THEN
            v_new_project_id    := NULL;
            v_new_board_id      := NULL;
        END IF;
        --
        IF v_new_project_id IS NOT NULL AND v_new_project_id != v_old_project_id THEN
            v_new_board_id      := NULL;
        END IF;
        --
        core.set_item('P0_CLIENT_ID',       v_new_client_id);
        core.set_item('P0_PROJECT_ID',      v_new_project_id);
        core.set_item('P0_BOARD_ID',        v_new_board_id);
        --
        core.set_item('$ACTIVE_CLIENT',     v_new_client_id,    in_if_exists => TRUE);
        core.set_item('$ACTIVE_PROJECT',    v_new_project_id,   in_if_exists => TRUE);
        core.set_item('$ACTIVE_BOARD',      v_new_board_id,     in_if_exists => TRUE);
        --

        /*
        v_swimlane_id       tsk_swimlanes.swimlane_id%TYPE;
        v_status_id         tsk_statuses.status_id%TYPE;
        v_category_id       tsk_categories.category_id%TYPE;
        --v_owner_id          tsk_s.owner_id%TYPE;

        core.set_item('P0_CLIENT_ID',       v_client_id);
        core.set_item('P0_PROJECT_ID',      v_project_id);
        core.set_item('P0_BOARD_ID',        v_board_id);
        core.set_item('P0_SWIMLANE_ID',     v_swimlane_id);
        core.set_item('P0_STATUS_ID',       v_status_id);
        core.set_item('P0_CATEGORY_ID',     v_category_id);

                core.set_item('P0_CLIENT_ID',       COALESCE(core.get_item('$ACTIVE_CLIENT'),   core.get_number_item('P0_CLIENT_ID')));
                core.set_item('P0_PROJECT_ID',      '');
                core.set_item('P0_BOARD_ID',        '');
                core.set_item('P0_SWIMLANE_ID',     '');
                core.set_item('P0_STATUS_ID',       '');
                core.set_item('P0_CATEGORY_ID',     '');
        */

        -- call page specific init procedures
        CASE core.get_page_id()
            WHEN 100 THEN tsk_p100.init_defaults();
            WHEN 105 THEN tsk_p105.init_defaults();
            ELSE NULL;
            END CASE;
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
        WHERE 1 = 1
            AND t.client_id     = COALESCE(in_client_id,    core.get_number_item('P0_CLIENT_ID'))
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
        WHERE 1 = 1
            AND t.client_id     = COALESCE(in_client_id,    core.get_number_item('P0_CLIENT_ID'))
            AND REGEXP_REPLACE(in_card_number, '\d+$', '') LIKE t.sequence_id || '%';
        --
        RETURN v_sequence_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;

END;
/

