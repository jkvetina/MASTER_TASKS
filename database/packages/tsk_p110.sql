CREATE OR REPLACE PACKAGE BODY tsk_p110 AS

    PROCEDURE process_bulk_init
    AS
    BEGIN
        -- init collection to gather moving cards
        APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(c_coll_card_filter);
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE process_bulk_filters
    AS
    BEGIN
        -- store grid lines into collection
        IF (core.get_grid_data('SELECTED_ROW') = 'Y' OR core.get_request() = 'PROCESS_ALL_ROWS') THEN
            APEX_COLLECTION.ADD_MEMBER (
                p_collection_name   => c_coll_card_filter,
                p_c001              => core.get_grid_data('CARD_ID')
            );
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE process_bulk_request
    AS
        v_source                tsk_cards%ROWTYPE;
        v_target                tsk_cards%ROWTYPE;
        v_affected              PLS_INTEGER;
    BEGIN
        v_source.project_id     := core.get_item('P110_SOURCE_PROJECT');
        v_source.board_id       := core.get_item('P110_SOURCE_BOARD');
        v_source.status_id      := core.get_item('P110_SOURCE_STATUS');
        v_source.swimlane_id    := core.get_item('P110_SOURCE_SWIMLANE');
        v_source.category_id    := core.get_item('P110_SOURCE_CATEGORY');
        v_source.owner_id       := core.get_item('P110_SOURCE_OWNER');
        --
        v_target.project_id     := core.get_item('P110_PROJECT_ID');
        v_target.board_id       := core.get_item('P110_BOARD_ID');
        v_target.status_id      := core.get_item('P110_STATUS_ID');
        v_target.swimlane_id    := core.get_item('P110_SWIMLANE_ID');
        v_target.category_id    := core.get_item('P110_CATEGORY');
        v_target.owner_id       := core.get_item('P110_OWNER_ID');
        --
        v_target.updated_by     := core.get_user_id();
        v_target.updated_at     := SYSDATE;

        -- process cards, skip cards not marked in collection
        UPDATE tsk_cards t
        SET t.project_id        = NVL(v_target.project_id,  t.project_id),
            t.board_id          = NVL(v_target.board_id,    t.board_id),
            t.status_id         = NVL(v_target.status_id,   t.status_id),
            t.swimlane_id       = NVL(v_target.swimlane_id, t.swimlane_id),
            t.category_id       = CASE WHEN v_source.category_id    IS NOT NULL THEN v_target.category_id END,
            t.owner_id          = CASE WHEN v_source.owner_id       IS NOT NULL THEN v_target.owner_id END,
            t.updated_by        = v_target.updated_by,
            t.updated_at        = v_target.updated_at
        WHERE 1 = 1
            AND t.client_id     = tsk_app.get_client_id()
            AND t.project_id    = tsk_app.get_project_id()
            AND t.card_id       IN (
                SELECT
                    c.c001 AS card_id
                FROM apex_collections c
                WHERE c.collection_name = c_coll_card_filter
            );
        --
        v_affected := SQL%ROWCOUNT;

        /*
        -- resort targets
        FOR s IN (
            SELECT
                t.card_id,
                ROW_NUMBER() OVER (ORDER BY t.order# NULLS LAST, t.card_id) * 10 AS order#
            FROM tsk_cards t
            WHERE 1 = 1
                AND t.client_id     = v_target.client_id
                AND t.project_id    = v_target.project_id
                AND t.board_id      = v_target.board_id
                AND t.status_id     = v_target.status_id
                AND t.swimlane_id   = v_target.swimlane_id
        ) LOOP
            UPDATE tsk_cards t
            SET t.order#        = s.order#
            WHERE t.card_id     = s.card_id
                AND (t.order#   != s.order# OR t.order# IS NULL);
        END LOOP;
        */

        -- clear collection
        APEX_COLLECTION.TRUNCATE_COLLECTION(c_coll_card_filter);
        --
        core.set_item('P0_SUCCESS_MESSAGE', NVL(v_affected, 0) || ' cards moved.');
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;

END;
/

