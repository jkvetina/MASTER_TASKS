CREATE OR REPLACE PACKAGE BODY tsk_p100 AS

    PROCEDURE init_defaults
    AS
        v_client_id         tsk_cards.client_id%TYPE    := tsk_app.get_client_id();
        v_project_id        tsk_cards.project_id%TYPE   := tsk_app.get_project_id();
        v_board_id          tsk_cards.board_id%TYPE     := tsk_app.get_board_id();
        v_swimlane_id       tsk_cards.swimlane_id%TYPE  := tsk_app.get_swimlane_id();
        v_card_id           tsk_cards.card_id%TYPE;
    BEGIN
        -- check if specific card was requested
        v_card_id := core.get_item('P100_CARD_ID');
        --
        IF v_card_id IS NOT NULL THEN
            BEGIN
                SELECT
                    t.client_id,
                    t.project_id,
                    t.board_id
                INTO
                    v_client_id,
                    v_project_id,
                    v_board_id
                FROM tsk_cards t
                WHERE t.card_id = v_card_id;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                core.raise_error('INVALID_CARD');
            END;

            -- update also board below card detail
            tsk_app.set_user_preferences (
                in_user_id          => core.get_user_id(),
                in_client_id        => v_client_id,
                in_project_id       => v_project_id,
                in_board_id         => v_board_id,
                in_swimlane_id      => v_swimlane_id
            );

            -- generate card link
            IF v_card_id IS NOT NULL THEN
                core.set_item('P100_CARD_LINK', tsk_app.get_card_link(v_card_id));
            END IF;
            --
        ELSE
            -- overwrite settings if new are passed in url
            IF core.get_request_url() LIKE '%p100_board_id=%' THEN
                v_client_id     := core.get_item('P100_CLIENT_ID');
                v_project_id    := core.get_item('P100_PROJECT_ID');
                v_board_id      := core.get_item('P100_BOARD_ID');
                --
                tsk_app.set_user_preferences (
                    in_user_id          => core.get_user_id(),
                    in_client_id        => v_client_id,
                    in_project_id       => v_project_id,
                    in_board_id         => v_board_id,
                    in_swimlane_id      => v_swimlane_id
                );
            END IF;
        END IF;

        -- set page items
        core.set_item('P100_CLIENT_ID',     v_client_id);
        core.set_item('P100_PROJECT_ID',    v_project_id);
        core.set_item('P100_BOARD_ID',      v_board_id);
        core.set_item('P100_CARDS_LINK',    core.get_page_url(100, in_reset => NULL));
        --
        FOR b IN (
            SELECT
                b.board_name,
                b.is_favorite
            FROM tsk_available_boards_v b
            WHERE b.board_id = v_board_id
        ) LOOP
            core.set_item('P100_HEADER',            b.board_name || ' Board');
            core.set_item('P100_IS_FAVORITE',       b.is_favorite);
            core.set_item('P100_BOOKMARK_ICON',     'fa-bookmark' || CASE WHEN b.is_favorite IS NULL THEN '-o' END);
        END LOOP;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE clob_append (
        io_clob             IN OUT NOCOPY   CLOB,
        in_content                          VARCHAR2
    )
    AS
    BEGIN
        IF LENGTH(in_content) > 0 THEN
            DBMS_LOB.WRITEAPPEND(io_clob, LENGTH(in_content), in_content);
        END IF;
    END;



    FUNCTION generate_board
    RETURN CLOB
    AS
        in_client_id        CONSTANT tsk_cards.client_id%TYPE       := tsk_app.get_client_id();
        in_project_id       CONSTANT tsk_cards.project_id%TYPE      := tsk_app.get_project_id();
        in_board_id         CONSTANT tsk_cards.board_id%TYPE        := tsk_app.get_board_id();
        in_swimlane_id      CONSTANT tsk_cards.swimlane_id%TYPE     := core.get_item('P100_SWIMLANE_ID');
        in_owner_id         CONSTANT tsk_cards.owner_id%TYPE        := core.get_item('P100_OWNER_ID');
        --
        v_statuses          PLS_INTEGER;
        out_clob            CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(out_clob, cache => TRUE);

        -- calculate number of columns
        SELECT COUNT(s.status_id)
        INTO v_statuses
        FROM tsk_statuses s
        WHERE s.client_id       = in_client_id
            AND s.project_id    = in_project_id
            AND s.is_active     = 'Y';

        -- generate grid
        clob_append(out_clob,
            '<div class="BOARD" style="' ||
            'grid-template-columns: 0 repeat(' || v_statuses || ', minmax(300px, 1fr));' ||
            '">');
        --
        FOR w IN (
            SELECT
                w.*,
                ROW_NUMBER() OVER (ORDER BY CASE WHEN w.swimlane_id = '-' THEN NULL ELSE w.order# END NULLS LAST) AS r#
            FROM tsk_swimlanes w
            WHERE w.client_id       = in_client_id
                AND w.project_id    = in_project_id
                AND (w.swimlane_id  = in_swimlane_id OR in_swimlane_id IS NULL)
                AND w.is_active     = 'Y'
            ORDER BY r#
        ) LOOP
            -- add swimlane spacer to headers
            clob_append(out_clob, '<div class="SPACER"></div>');

            -- create headers for each swimlane
            FOR s IN (
                SELECT
                    s.status_id,
                    s.status_name,
                    s.is_badge,
                    SUBSTR(u.user_name, 1, INSTR(u.user_name, ' ') - 1) AS user_name,
                    ROW_NUMBER() OVER (ORDER BY s.order# NULLS LAST) AS r#
                FROM tsk_lov_statuses_v s
                LEFT JOIN app_users_v u
                    ON u.user_id        = in_owner_id
                ORDER BY s.order#
            ) LOOP
                FOR d IN (
                    SELECT
                        COUNT(DISTINCT t.card_id)       AS count_cards,
                        COUNT(NVL(l.checklist_id, 0))   AS count_checks,
                        COUNT(l.checklist_done)         AS count_done
                        --
                    FROM tsk_p100_cards_v t
                    LEFT JOIN tsk_card_checklist l
                        ON l.card_id        = t.card_id
                    WHERE t.client_id       = in_client_id
                        AND t.project_id    = in_project_id
                        AND t.board_id      = in_board_id
                        AND t.status_id     = s.status_id
                        AND t.swimlane_id   = w.swimlane_id
                ) LOOP
                    clob_append(out_clob, '<div class="TARGET_LIKE">');
                    clob_append(out_clob, '<h3>' || s.status_name ||
                        CASE WHEN d.count_cards > 0 THEN '<span class="BADGE' || CASE WHEN s.is_badge IS NULL THEN ' DECENT' END || '">' || d.count_cards || '</span>' END ||
                        CASE WHEN d.count_cards > 0 THEN '<span class="PROGRESS">' || d.count_done || '/' || d.count_checks || '</span>' END ||
                        '</h3>' ||
                        '<div class="PROGRESS_BAR"><div style="width: ' || NVL(FLOOR(d.count_done / NULLIF(d.count_checks, 0) * 100), 0) || '%;"></div></div>'
                    );
                    clob_append(out_clob, '</div>');
                END LOOP;
            END LOOP;

            -- add swimlane name
            clob_append(out_clob, '<div class="SWIMLANE" id="SWIMLANE_' || w.swimlane_id || '"><span>' || w.swimlane_name || '</span></div>');

            -- create status columns (card holders) for each swimlanes
            FOR s IN (
                SELECT
                    s.status_id,
                    s.is_colored
                FROM tsk_lov_statuses_v s
                ORDER BY s.order#
            ) LOOP
                clob_append(out_clob, '<div class="TARGET" id="STATUS_' || s.status_id || '_SWIMLANE_' || w.swimlane_id || '">');
                --
                FOR t IN (
                    SELECT
                        t.card_id,
                        t.card_number,
                        t.card_name,
                        t.deadline_at,
                        t.card_link,
                        t.card_progress,
                        t.color_bg
                    FROM tsk_p100_cards_v t
                    WHERE t.client_id       = in_client_id
                        AND t.project_id    = in_project_id
                        AND t.board_id      = in_board_id
                        AND t.status_id     = s.status_id
                        AND t.swimlane_id   = w.swimlane_id
                    ORDER BY t.order#
                ) LOOP
                    clob_append(out_clob,
                        '<div class="CARD" draggable="true" id="CARD_' || t.card_id || '" style="' ||
                            CASE WHEN s.is_colored = 'Y' AND t.color_bg IS NOT NULL             THEN 'border-left: 8px solid ' || t.color_bg || '; ' END ||
                            CASE WHEN s.is_colored = 'Y' AND t.deadline_at <= TRUNC(SYSDATE)    THEN 'border-right: 8px solid #222; ' END ||
                            '">' ||
                        '<a href="' || t.card_link || '">' ||
                        CASE WHEN t.card_progress IS NOT NULL
                            THEN '<span class="PROGRESS">' || t.card_progress || '</span>'
                            END ||
                        '<span class="CARD_ID">' || NVL(t.card_number, c_card_prefix || t.card_id) || '</span>' ||
                        '<span style="color: #888;"> &' || 'ndash; </span>' || t.card_name ||
                        '</a></div>'
                    );
                END LOOP;
                --
                clob_append(out_clob, '</div>');
            END LOOP;
        END LOOP;
        --
        clob_append(out_clob, '</div>');
        --
        RETURN out_clob;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE ajax_update_card_on_drag
    AS
    BEGIN
        -- update card status (column)
        UPDATE tsk_cards t
        SET t.status_id     = APEX_APPLICATION.G_X02,
            t.swimlane_id   = APEX_APPLICATION.G_X03
        WHERE t.card_id     = APEX_APPLICATION.G_X01;
        --
        IF SQL%ROWCOUNT = 1 THEN
            -- update order of passed cards
            FOR s IN (
                SELECT
                    COLUMN_VALUE    AS card_id,
                    ROWNUM * 10     AS order#
                FROM APEX_STRING.SPLIT(APEX_APPLICATION.G_X04, ':')
            ) LOOP
                UPDATE tsk_cards t
                SET t.order#        = s.order#
                WHERE t.card_id     = s.card_id
                    AND (t.order#   != s.order# OR t.order# IS NULL);
            END LOOP;

            -- message for app
            HTP.P('Card ' || c_card_prefix || APEX_APPLICATION.G_X01 || ' updated');
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    PROCEDURE bookmark_current
    AS
        rec                 tsk_boards_fav%ROWTYPE;
    BEGIN
        rec.user_id         := core.get_user_id();
        rec.client_id       := tsk_app.get_client_id();
        rec.project_id      := tsk_app.get_project_id();
        rec.board_id        := tsk_app.get_board_id();
        --
        BEGIN
            SELECT t.*
            INTO rec
            FROM tsk_boards_fav t
            WHERE t.user_id         = rec.user_id
                AND t.client_id     = rec.client_id
                AND t.project_id    = rec.project_id
                AND t.board_id      = rec.board_id;
            --
            tsk_tapi.user_fav_boards(rec, 'D');     -- remove
            --
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --rec.swimlanes     := core.get_item('$SWIMLANE_ID');
            --rec.owners        := core.get_item('$OWNER_ID');
            --
            tsk_tapi.user_fav_boards(rec, 'C');     -- add
        END;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;

END;
/

