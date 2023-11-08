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

        -- merge target
        core.set_item('P105_MERGE_URL',     APEX_PAGE.GET_URL (
            p_page      => 108,
            p_items     => 'P108_CARD_ID,P108_TARGET_CARD_ID',
            p_values    => rec.card_id || ','
        ));

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
        in_request          CONSTANT VARCHAR2(64)   := core.get_request();
        in_detail           CONSTANT BOOLEAN        := core.get_page_id() = 105;
        --
        v_sequence          tsk_sequences.sequence_id%TYPE;
    BEGIN
        rec.card_id         := CASE WHEN in_detail THEN core.get_item('P105_CARD_ID')           ELSE core.get_grid_data('CARD_ID') END;
        rec.card_number     := CASE WHEN in_detail THEN core.get_item('P105_CARD_NUMBER')       ELSE core.get_grid_data('CARD_NUMBER') END;
        rec.card_name       := CASE WHEN in_detail THEN core.get_item('P105_CARD_NAME')         ELSE core.get_grid_data('CARD_NAME') END;
        rec.card_desc       := CASE WHEN in_detail THEN core.get_item('P105_CARD_DESC') END;
        rec.board_id        := CASE WHEN in_detail THEN core.get_item('P105_BOARD_ID')          ELSE core.get_grid_data('BOARD_ID') END;
        rec.client_id       := CASE WHEN in_detail THEN core.get_item('P105_CLIENT_ID')         ELSE core.get_grid_data('CLIENT_ID') END;
        rec.project_id      := CASE WHEN in_detail THEN core.get_item('P105_PROJECT_ID')        ELSE core.get_grid_data('PROJECT_ID') END;
        rec.status_id       := CASE WHEN in_detail THEN core.get_item('P105_STATUS_ID')         ELSE core.get_grid_data('STATUS_ID') END;
        rec.swimlane_id     := CASE WHEN in_detail THEN core.get_item('P105_SWIMLANE_ID')       ELSE core.get_grid_data('SWIMLANE_ID') END;
        rec.category_id     := CASE WHEN in_detail THEN core.get_item('P105_CATEGORY_ID')       ELSE core.get_grid_data('CATEGORY_ID') END;
        rec.owner_id        := CASE WHEN in_detail THEN core.get_item('P105_OWNER_ID')          ELSE core.get_grid_data('OWNER_ID') END;
        rec.tags            := CASE WHEN in_detail THEN core.get_item('P105_TAGS')              ELSE core.get_grid_data('TAGS') END;
        rec.order#          := CASE WHEN in_detail THEN core.get_item('P105_ORDER')             ELSE core.get_grid_data('ORDER#') END;
        --
        rec.deadline_at     := core.get_date(CASE WHEN in_detail THEN core.get_item('P105_DEADLINE_AT') ELSE core.get_grid_data('DEADLINE_AT') END);

        -- calculate next card_number
        v_sequence          := CASE WHEN in_detail THEN core.get_item('P105_SEQUENCE') ELSE core.get_grid_data('SEQUENCE') END;
        --
        IF rec.card_number IS NULL AND v_sequence IS NOT NULL THEN
            rec.card_number := tsk_app.get_card_next_sequence (
                in_sequence_id  => v_sequence,
                in_client_id    => rec.client_id
            );
        END IF;

        -- create/update record
        tsk_tapi.cards(rec,
            in_action => CASE WHEN in_request LIKE 'DELETE_CARD%' THEN 'D' END
        );
        --
        IF in_request LIKE 'DELETE_CARD%' THEN
            app.set_success_message('Card ' || NVL(rec.card_number, '#' || rec.card_id) || ' deleted.');
            --
            RETURN;
        END IF;

        -- save attachements
        IF core.get_item('P105_ATTACHED_FILES') IS NOT NULL THEN
            save_attachements();
        END IF;

        -- create/update comments
        IF core.get_item('P105_COMMENT') IS NOT NULL THEN
            upsert_comment (
                in_card_id          => rec.card_id,
                in_comment_id       => core.get_item('P105_COMMENT_ID'),
                in_comment_payload  => core.get_item('P105_COMMENT')
            );
        END IF;

        --
        -- special actions depending on button pressed (or action called)
        --
        IF in_request LIKE 'MOVE_TO_TOP%' THEN
            move_card_to_top (
                in_card_id => rec.card_id
            );
            --
            app.set_success_message('Card ' || NVL(rec.card_number, '#' || rec.card_id) || ' moved to the top.');
            --
        ELSIF in_request LIKE 'DUPLICATE_CARD%' THEN
            rec.card_id := duplicate_card (
                in_card_id => rec.card_id
            );
            --
            app.set_success_message('Card ' || NVL(rec.card_number, '#' || rec.card_id) || ' duplicated.');
            --
        ELSIF in_request LIKE 'SPLIT_CARD%' THEN
            rec.card_id := split_checklist (
                in_card_id => rec.card_id
            );
            --
            app.set_success_message('Card ' || NVL(rec.card_number, '#' || rec.card_id) || ' splited.');
            --
        ELSIF in_request LIKE 'MERGE_CARD%' THEN
            merge_checklist (
                in_source_card_id   => rec.card_id,
                in_target_card_id   => core.get_number_item('$TARGET_CARD_ID')
            );
            --
            app.set_success_message('Card ' || NVL(rec.card_number, '#' || rec.card_id) || ' merged.');
            --
        ELSE
            app.set_success_message('Card ' || NVL(rec.card_number, '#' || rec.card_id) || ' updated.');
        END IF;
        --
        core.set_item('P105_CARD_ID', rec.card_id);
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
        DELETE FROM tsk_card_comments t
        WHERE t.card_id     = in_card_id;
        --
        DELETE FROM tsk_card_commits t
        WHERE t.card_id     = in_card_id;
        --
        DELETE FROM tsk_card_files t
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



    FUNCTION duplicate_card (
        in_card_id          tsk_cards.card_id%TYPE
    )
    RETURN tsk_cards.card_id%TYPE
    AS
        rec                 tsk_cards%ROWTYPE;
    BEGIN
        BEGIN
            SELECT t.* INTO rec
            FROM tsk_cards t
            WHERE t.card_id = in_card_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            core.raise_error('CARD_NOT_FOUND', in_card_id);
        END;
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

        -- copy checklist
        INSERT INTO tsk_card_checklist (card_id, checklist_id, checklist_item, checklist_done, order#, updated_by, updated_at)
        SELECT
            rec.card_id,
            tsk_checklist_id.NEXTVAL    AS checklist_id,
            t.checklist_item,
            t.checklist_done,
            t.order#,
            t.updated_by,
            t.updated_at
        FROM tsk_card_checklist t
        WHERE t.card_id = in_card_id;

        -- also copy comments and files
        INSERT INTO tsk_card_comments (card_id, comment_id, comment_payload, updated_by, updated_at)
        SELECT
            rec.card_id,
            t.comment_id,           -- reuse same number
            t.comment_payload,
            t.updated_by,
            t.updated_at
        FROM tsk_card_comments t
        WHERE t.card_id = in_card_id;
        --
        INSERT INTO tsk_card_files (card_id, file_id, file_name, file_mime, file_size, file_payload, updated_by, updated_at)
        SELECT
            rec.card_id,
            tsk_file_id.NEXTVAL     AS file_id,
            t.file_name,
            t.file_mime,
            t.file_size,
            t.file_payload,
            t.updated_by,
            t.updated_at
        FROM tsk_card_files t
        WHERE t.card_id = in_card_id;
        --
        RETURN rec.card_id;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE move_card_to_top (
        in_card_id          tsk_cards.card_id%TYPE
    )
    AS
    BEGIN
        -- @TODO: check permissions for related project
        UPDATE tsk_cards t
        SET t.order#        = 0
        WHERE t.card_id     = in_card_id;
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
        IF core.get_request() LIKE 'DELETE_CARD%' THEN
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
        rec.checklist_item  := TRIM(core.get_grid_data('CHECKLIST_ITEM'));
        rec.checklist_done  := core.get_grid_data('CHECKLIST_DONE');
        rec.checklist_level := core.get_grid_data('CHECKLIST_LEVEL');
        rec.order#          := LPAD(REPLACE(core.get_grid_data('NEW_ORDER'), '#', ''), 3, '0');
        rec.updated_by      := core.get_user_id();
        rec.updated_at      := SYSDATE;

        -- update level
        IF rec.checklist_item LIKE '-%' THEN
            rec.checklist_level := LENGTH(rec.checklist_item) - LENGTH(LTRIM(rec.checklist_item, '-'));
            rec.checklist_item  := LTRIM(LTRIM(rec.checklist_item, '-'));
        END IF;

        -- proceed with updates
        IF (core.get_grid_action() = 'D' OR rec.checklist_item IS NULL) THEN
            DELETE FROM tsk_card_checklist t
            WHERE t.card_id         = rec.card_id
                AND t.checklist_id  = rec.checklist_id;
            --
        ELSIF rec.checklist_id > 0 THEN
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



    PROCEDURE upsert_comment (
        in_card_id          tsk_card_comments.card_id%TYPE,
        in_comment_id       tsk_card_comments.comment_id%TYPE,
        in_comment_payload  tsk_card_comments.comment_payload%TYPE
    )
    AS
        rec                 tsk_card_comments%ROWTYPE;
    BEGIN
        rec.card_id         := in_card_id;
        rec.comment_id      := CASE WHEN in_comment_id IS NULL THEN tsk_comment_id.NEXTVAL ELSE in_comment_id END;
        rec.comment_payload := in_comment_payload;
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



    PROCEDURE delete_comment (
        in_card_id          tsk_card_comments.card_id%TYPE,
        in_comment_id       tsk_card_comments.comment_id%TYPE
    )
    AS
        rec                 tsk_card_comments%ROWTYPE;
    BEGIN
        BEGIN
            SELECT * INTO rec
            FROM tsk_card_comments c
            WHERE c.card_id         = in_card_id
                AND c.comment_id    = in_comment_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN;
        END;
        --
        tsk_tapi.card_comments (rec,
            in_action       => 'D',
            in_card_id      => rec.card_id,
            in_comment_id   => rec.comment_id
        );
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION split_checklist (
        in_card_id          tsk_cards.card_id%TYPE
    )
    RETURN tsk_cards.card_id%TYPE
    AS
        out_card_id         tsk_cards.card_id%TYPE;
    BEGIN
        out_card_id := duplicate_card (
            in_card_id => in_card_id
        );

        -- remove checked/done items from target card
        DELETE FROM tsk_card_checklist t
        WHERE t.card_id             = out_card_id
            AND t.checklist_done    IS NOT NULL;

        -- remove non checked items from source card
        DELETE FROM tsk_card_checklist t
        WHERE t.card_id             = in_card_id
            AND t.checklist_done    IS NULL;
        --
        RETURN out_card_id;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE merge_checklist (
        in_source_card_id   tsk_cards.card_id%TYPE,
        in_target_card_id   tsk_cards.card_id%TYPE
    )
    AS
    BEGIN
        UPDATE tsk_card_checklist t
        SET t.card_id       = in_target_card_id
        WHERE t.card_id     = in_source_card_id;
        --
        -- @TODO: move description, attachements, comments, commits, tags...
        --
        DELETE FROM tsk_cards t
        WHERE t.card_id     = in_source_card_id;
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



    PROCEDURE delete_file (
        in_file_id          tsk_card_files.file_id%TYPE
    )
    AS
    BEGIN
        DELETE FROM tsk_card_files t
        WHERE t.file_id     = in_file_id
            AND t.card_id   = core.get_item('P105_CARD_ID');
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;

END;
/

