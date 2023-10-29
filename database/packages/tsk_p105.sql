CREATE OR REPLACE PACKAGE BODY tsk_p105 AS

    PROCEDURE init_defaults
    AS
        rec                 tsk_cards%ROWTYPE;
    BEGIN
        -- get cards details
        rec.card_id := core.get_item('P105_CARD_ID');

        -- for existing card
        IF rec.card_id IS NOT NULL THEN
            BEGIN
                SELECT t.* INTO rec
                FROM tsk_cards t
                --
                -- @TODO: AUTH
                --
                WHERE t.card_id = rec.card_id;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                core.raise_error('INVALID_CARD');
            END;

            -- calculate prev/next cards
            FOR c IN (
                SELECT t.card_id, t.prev_card, t.next_card
                FROM tsk_p100_cards_v t
                WHERE t.card_id = rec.card_id
            ) LOOP
                core.set_item('P105_PREV_CARD_ID', NULLIF(c.prev_card, c.card_id));
                core.set_item('P105_NEXT_CARD_ID', NULLIF(c.next_card, c.card_id));
            END LOOP;

            -- calculate tab badges
            FOR c IN (
                SELECT
                    b.item_name,
                    b.badge
                FROM tsk_p105_badges_v b
            ) LOOP
                core.set_item(c.item_name, c.badge);
            END LOOP;
            --
            core.set_item('P105_BADGE_DESC', CASE WHEN LENGTH(rec.card_desc) > 0
                THEN ' &nbsp;<span class="BADGE ICON"><span class="fa fa-warning" style="color: orange;"></span></span>'
                END);
            --
        ELSE
            -- get defaults for new card
            core.set_item('P105_CLIENT_ID',     tsk_app.get_client_id());
            core.set_item('P105_PROJECT_ID',    tsk_app.get_project_id());
            core.set_item('P105_BOARD_ID',      tsk_app.get_board_id());
            core.set_item('P105_OWNER_ID',      core.get_user_id());
            --
            FOR c IN (
                SELECT s.status_id
                FROM tsk_lov_statuses_v s
                WHERE s.is_default = 'Y'
            ) LOOP
                core.set_item('P105_STATUS_ID', c.status_id);
            END LOOP;
            --
            FOR c IN (
                SELECT s.category_id AS category_id
                FROM tsk_lov_categories_v s
                WHERE s.is_default = 'Y'
            ) LOOP
                core.set_item('P105_CATEGORY_ID', c.category_id);
            END LOOP;
            --
            FOR c IN (
                SELECT t.sequence_id
                FROM tsk_boards_v t
                WHERE t.board_id = tsk_app.get_board_id()
            ) LOOP
                core.set_item('P105_SEQUENCE', c.sequence_id);
            END LOOP;
        END IF;

        -- overwrite some page items
        core.set_item('P105_CARD_LINK',     tsk_nav.get_card_link(rec.card_id, 'EXTERNAL'));
        core.set_item('P105_AUDIT',         TO_CHAR(rec.updated_at, 'YYYY-MM-DD HH24:MI') || ' ' || rec.updated_by);
        core.set_item('P105_TAGS',          LTRIM(RTRIM(REPLACE(rec.tags, ':', ' '))));

        -- calculate page header
        core.set_item('P105_HEADER', CASE WHEN rec.card_id IS NOT NULL THEN 'Update Card ' || NVL(rec.card_number, tsk_p100.c_card_prefix || rec.card_id) ELSE core.get_page_name(105) END);
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_card
    AS
        rec                 tsk_cards%ROWTYPE;
        v_is_detail         CONSTANT BOOLEAN := core.get_page_id() = 105;
        v_sequence          tsk_sequences.sequence_id%TYPE;
    BEGIN
        rec.card_id         := CASE WHEN v_is_detail THEN core.get_item('P105_CARD_ID')     ELSE core.get_grid_data('CARD_ID') END;
        rec.card_number     := CASE WHEN v_is_detail THEN core.get_item('P105_CARD_NUMBER') ELSE core.get_grid_data('CARD_NUMBER') END;
        rec.card_name       := CASE WHEN v_is_detail THEN core.get_item('P105_CARD_NAME')   ELSE core.get_grid_data('CARD_NAME') END;
        rec.card_desc       := CASE WHEN v_is_detail THEN core.get_item('P105_CARD_DESC')   END;
        rec.board_id        := CASE WHEN v_is_detail THEN core.get_item('P105_BOARD_ID')    ELSE core.get_grid_data('BOARD_ID') END;
        rec.client_id       := CASE WHEN v_is_detail THEN core.get_item('P105_CLIENT_ID')   ELSE core.get_grid_data('CLIENT_ID') END;
        rec.project_id      := CASE WHEN v_is_detail THEN core.get_item('P105_PROJECT_ID')  ELSE core.get_grid_data('PROJECT_ID') END;
        rec.status_id       := CASE WHEN v_is_detail THEN core.get_item('P105_STATUS_ID')   ELSE core.get_grid_data('STATUS_ID') END;
        rec.swimlane_id     := CASE WHEN v_is_detail THEN core.get_item('P105_SWIMLANE_ID') ELSE core.get_grid_data('SWIMLANE_ID') END;
        rec.category_id     := CASE WHEN v_is_detail THEN core.get_item('P105_CATEGORY_ID') ELSE core.get_grid_data('CATEGORY_ID') END;
        rec.owner_id        := CASE WHEN v_is_detail THEN core.get_item('P105_OWNER_ID')    ELSE core.get_grid_data('OWNER_ID') END;
        rec.tags            := CASE WHEN v_is_detail THEN core.get_item('P105_TAGS')        ELSE core.get_grid_data('TAGS') END;
        rec.order#          := CASE WHEN v_is_detail THEN core.get_item('P105_ORDER')       ELSE core.get_grid_data('ORDER#') END;
        --
        rec.deadline_at     := core.get_date(CASE WHEN v_is_detail THEN core.get_item('P105_DEADLINE_AT') ELSE core.get_grid_data('DEADLINE_AT') END);

        -- calculate next card_number
        v_sequence          := CASE WHEN v_is_detail THEN core.get_item('P105_SEQUENCE') ELSE core.get_grid_data('SEQUENCE') END;
        --
        IF rec.card_number IS NULL AND v_sequence IS NOT NULL THEN
            rec.card_number := tsk_app.get_card_next_sequence (
                in_sequence_id  => v_sequence,
                in_client_id    => rec.client_id
            );
        END IF;

        -- create/update record
        tsk_tapi.cards(rec,
            in_action => CASE WHEN core.get_page_id() = 105 THEN SUBSTR(core.get_request(), 1, 1) END
        );
        --
        core.set_item('P105_CARD_ID', rec.card_id);
        --
        app.set_success_message('Card ' || NVL(rec.card_number, '#' || rec.card_id) || ' updated.');
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE delete_card (
        in_card_id          tsk_cards.card_id%TYPE
    )
    AS
    BEGIN
        --
        -- @TODO: CHECK AUTH
        --
        DELETE FROM tsk_card_checklist t
        WHERE t.card_id     = in_card_id;
        --
        DELETE FROM tsk_cards t
        WHERE t.card_id     = in_card_id;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_checklist
    AS
        rec                 tsk_card_checklist%ROWTYPE;
    BEGIN
        -- ignore any changes when deleting whole card
        IF core.get_request() = 'DELETE_CARD' THEN
            RETURN;
        END IF;

        -- verify if card exists
        BEGIN
            SELECT t.card_id INTO rec.card_id
            FROM tsk_cards t
            WHERE t.card_id = COALESCE(core.get_grid_data('CARD_ID'), core.get_item('P105_CARD_ID'));
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            core.raise_error('INVALID_CARD');
        END;

        -- prepare data
        rec.checklist_id    := core.get_grid_data('CHECKLIST_ID');
        rec.checklist_item  := NULLIF(TRIM(core.get_grid_data('CHECKLIST_ITEM')), '-');
        rec.checklist_done  := core.get_grid_data('CHECKLIST_DONE');
        rec.order#          := TRIM(core.get_grid_data('ORDER#'));
        rec.updated_by      := core.get_user_id();
        rec.updated_at      := SYSDATE;

        -- split text to order#
        IF REGEXP_LIKE(rec.checklist_item, '^\d') THEN
            rec.order#          := SUBSTR(rec.checklist_item, 1, INSTR(rec.checklist_item || ' ', ' ') - 1);  -- ^[^\s]+
            rec.checklist_item  := LTRIM(REPLACE(rec.checklist_item, rec.order#, ''));
            --
            IF SUBSTR(rec.order#, -1, 1) != '.' AND SUBSTR(rec.order#, -1, 1) != ')' THEN
                rec.order#      := rec.order# || ')';
            END IF;
        END IF;

        -- proceed with updates
        IF (core.get_grid_action() = 'D' OR rec.checklist_item IS NULL) THEN
            DELETE FROM tsk_card_checklist t
            WHERE t.card_id         = rec.card_id
                AND t.checklist_id  = rec.checklist_id;
            --
            RETURN;
        END IF;
        --
        IF rec.checklist_id > 0 THEN
            UPDATE tsk_card_checklist t
            SET ROW = rec
            WHERE t.card_id         = rec.card_id
                AND t.checklist_id  = rec.checklist_id;
        ELSE
            rec.checklist_id := tsk_checklist_id.NEXTVAL;
            --
            INSERT INTO tsk_card_checklist
            VALUES rec;
        END IF;

        -- update also card
        UPDATE tsk_cards t
        SET t.updated_at        = rec.updated_at,
            t.updated_by        = rec.updated_by
        WHERE t.card_id         = rec.card_id;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_badge_icon (
        in_value            NUMBER
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN CASE WHEN in_value > 0 THEN
            ' &nbsp;<span class="fa ' ||
            CASE
                WHEN in_value < 10
                    THEN 'fa-number-' || in_value  -- LOWER(TO_CHAR(TO_DATE(in_value, 'J'), 'JSP'))
                ELSE 'fa-arrow-circle-down'
                END ||
            '"></span>' END;
    END;



    PROCEDURE save_comment
    AS
        rec                 tsk_card_comments%ROWTYPE;
    BEGIN
        rec.card_id         := core.get_item('P105_CARD_ID');
        rec.comment_id      := core.get_item('P105_COMMENT_ID');
        rec.comment_payload := core.get_item('P105_COMMENT');
        --
        IF rec.comment_id IS NULL THEN
            rec.comment_id  := tsk_comment_id.NEXTVAL;
        END IF;
        --
        rec.updated_by      := core.get_user_id();
        rec.updated_at      := SYSDATE;
        --
        IF rec.comment_id IS NOT NULL AND rec.comment_payload IS NOT NULL THEN
            tsk_tapi.card_comments (rec,
                in_action               => 'C',
                in_card_id              => rec.card_id,
                in_comment_id           => rec.comment_id
            );
            --
            core.set_item('P105_COMMENT_ID',    '');
            core.set_item('P105_COMMENT',       '');
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE ajax_delete_comment
    AS
        rec                 tsk_card_comments%ROWTYPE;
    BEGIN
        rec.card_id         := APEX_APPLICATION.G_X01;
        rec.comment_id      := APEX_APPLICATION.G_X02;
        --
        IF rec.card_id IS NOT NULL AND rec.comment_id IS NOT NULL THEN
            tsk_tapi.card_comments (rec,
                in_action               => 'D',
                in_card_id              => rec.card_id,
                in_comment_id           => rec.comment_id
            );
            --
            IF SQL%ROWCOUNT = 1 THEN
                HTP.P('Comment deleted');
            END IF;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_split_checklist
    AS
        rec                 tsk_cards%ROWTYPE;
        v_source_card_id    tsk_cards.card_id%TYPE;
    BEGIN
        v_source_card_id := core.get_item('P105_CARD_ID');
        --
        SELECT t.* INTO rec
        FROM tsk_cards t
        WHERE t.card_id = v_source_card_id;
        --
        rec.card_id         := tsk_card_id.NEXTVAL;
        rec.card_number     := tsk_app.get_card_next_sequence (
                                    in_sequence_id  => tsk_app.get_card_sequence (
                                                            in_card_number  => rec.card_number,
                                                            in_client_id    => rec.client_id
                                                        ),
                                    in_client_id    => rec.client_id
                                );
        --
        INSERT INTO tsk_cards VALUES rec;
        --
        UPDATE tsk_card_checklist t
        SET t.card_id               = rec.card_id
        WHERE t.card_id             = v_source_card_id
            AND t.checklist_done    IS NULL;
        --
        core.set_item('P105_CARD_ID', rec.card_id);
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_merge_checklist
    AS
        v_source_card_id    tsk_cards.card_id%TYPE;
        v_target_card_id    tsk_cards.card_id%TYPE;
    BEGIN
        v_source_card_id    := core.get_item('$CARD_ID');
        v_target_card_id    := core.get_item('$TARGET_CARD_ID');
        --
        UPDATE tsk_card_checklist t
        SET t.card_id       = v_target_card_id
        WHERE t.card_id     = v_source_card_id;
        --
        -- @TODO: move description, attachements, comments, commits, tags...
        --
        DELETE FROM tsk_cards t
        WHERE t.card_id     = v_source_card_id;
        --
        -- and now we should redirect user to the target card
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE save_attachements
    AS
        rec         tsk_card_files%ROWTYPE;
    BEGIN
        FOR c IN (
            SELECT f.*
            FROM apex_application_temp_files f
            JOIN APEX_STRING.SPLIT(core.get_item('P105_ATTACHED_FILES'), ':') i
                ON i.column_value   = f.name
            WHERE f.application_id  = core.get_app_id()
        ) LOOP
            rec.card_id         := core.get_item('P105_CARD_ID');
            rec.file_id         := NULL;
            rec.file_name       := c.filename;
            rec.file_mime       := c.mime_type;
            rec.file_size       := DBMS_LOB.GETLENGTH(c.blob_content);
            rec.file_payload    := c.blob_content;
            --
            tsk_tapi.card_files (rec);
        END LOOP;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE download_attachement (
        in_file_id              tsk_card_files.file_id%TYPE
    ) AS
        rec                     tsk_card_files%ROWTYPE;
    BEGIN
        BEGIN
            SELECT f.* INTO rec
            FROM tsk_card_files f
            JOIN tsk_cards t
                ON t.card_id        = f.card_id
            WHERE f.file_id         = in_file_id
                AND t.project_id    = tsk_app.get_project_id();
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            core.raise_error('FILE_NOT_FOUND');
        END;
        --
        core.download_file (
            in_file_name        => rec.file_name,
            in_file_mime        => rec.file_mime,
            in_file_payload     => rec.file_payload
        );
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE move_card_to_top
    AS
    BEGIN
        -- @TODO: check permissions for related project
        UPDATE tsk_cards t
        SET t.order#        = 0
        WHERE t.card_id     = COALESCE(core.get_item('$CARD_ID'), core.get_grid_data('CARD_ID'));
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;

END;
/

