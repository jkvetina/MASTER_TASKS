CREATE OR REPLACE PACKAGE BODY tsk_p100 AS

    PROCEDURE init_defaults
    AS
        v_card_id           tsk_cards.card_id%TYPE;
    BEGIN
        -- load last project/board on login
        IF tsk_app.get_board_id() IS NULL THEN
            FOR c IN (
                SELECT t.*
                FROM tsk_recent t
                WHERE t.user_id = core.get_user_id()
                ORDER BY t.updated_at DESC NULLS LAST
                FETCH FIRST 1 ROWS ONLY
            ) LOOP
                tsk_app.set_context (
                    in_client_id        => c.client_id,
                    in_project_id       => c.project_id,
                    in_board_id         => c.board_id,
                    in_swimlane_id      => c.swimlane_id,
                    in_status_id        => c.status_id,
                    in_category_id      => c.category_id,
                    in_owner_id         => c.owner_id
                );
            END LOOP;
        END IF;

        -- set page items
        core.set_item('P100_CARD_LINK',     '');
        core.set_item('P100_CARDS_LINK',    core.get_page_url(100, in_reset => NULL));

        -- check if specific card was requested
        BEGIN
            SELECT t.card_id INTO v_card_id
            FROM tsk_cards t
            WHERE t.card_id = core.get_number_item('P100_CARD_ID');
            --
            IF v_card_id IS NOT NULL THEN
                core.set_item('P100_CARD_LINK', tsk_nav.get_card_link(v_card_id));
            END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        END;

        -- set page items
        FOR b IN (
            SELECT
                b.board_name,
                b.is_favorite
            FROM tsk_available_boards_v b
            WHERE b.board_id = tsk_app.get_board_id()
        ) LOOP
            core.set_item('P100_HEADER',            b.board_name || ' Board');
            core.set_item('P100_IS_FAVORITE',       b.is_favorite);
            core.set_item('P100_BOOKMARK_ICON',     'fa-bookmark' || CASE WHEN b.is_favorite IS NULL THEN '-o' END);
        END LOOP;
        --
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
        in_swimlane_id      CONSTANT tsk_cards.swimlane_id%TYPE     := tsk_app.get_swimlane_id();
        in_owner_id         CONSTANT tsk_cards.owner_id%TYPE        := tsk_app.get_owner_id();
        --
        v_statuses          PLS_INTEGER;
        v_swimlanes         PLS_INTEGER;
        out_clob            CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(out_clob, cache => TRUE);

        -- calculate number of columns
        SELECT COUNT(s.status_id)
        INTO v_statuses
        FROM tsk_statuses s
        WHERE s.client_id       = in_client_id
            AND s.project_id    = in_project_id
            AND s.is_active     = 'Y'
            AND (s.row_order#   IS NULL OR s.row_order# = 1);

        -- calculate number of swimlanes
        SELECT COUNT(w.swimlane_id)
        INTO v_swimlanes
        FROM tsk_swimlanes w
        WHERE w.client_id       = in_client_id
            AND w.project_id    = in_project_id
            AND (w.swimlane_id  = in_swimlane_id OR in_swimlane_id IS NULL)
            AND w.is_active     = 'Y';

        -- generate grid
        clob_append(out_clob,
            '<div class="BOARD" style="' ||
            'grid-template-columns: ' || CASE WHEN v_swimlanes > 1 THEN '0 ' END || 'repeat(' || v_statuses || ', minmax(320px, 1fr));' ||
            '">');
        --
        FOR w IN (
            SELECT
                w.swimlane_id,
                w.swimlane_name,
                ROW_NUMBER() OVER (ORDER BY CASE WHEN w.swimlane_id = '-' THEN NULL ELSE w.order# END NULLS LAST) AS r#,
                COUNT(w.swimlane_id) OVER() AS swimlanes,
                b.is_simple
            FROM tsk_swimlanes w
            LEFT JOIN tsk_boards b
                ON b.client_id      = in_client_id
                AND b.board_id      = in_board_id
            WHERE w.client_id       = in_client_id
                AND w.project_id    = in_project_id
                AND (w.swimlane_id  = in_swimlane_id OR in_swimlane_id IS NULL)
                AND w.is_active     = 'Y'
            ORDER BY r#
        ) LOOP
            -- add swimlane name
            IF v_swimlanes > 1 THEN
                clob_append(out_clob, '<div class="SWIMLANE" id="SWIMLANE_' || w.swimlane_id || '"><span>' || w.swimlane_name || '</span></div>');
            END IF;

            -- create status columns (card holders) for each swimlanes
            FOR s IN (
                SELECT
                    s.status_id,
                    s.status_name,
                    s.is_badge,
                    s.is_colored,
                    --
                    d.count_cards,
                    d.count_checks,
                    d.count_done,
                    --
                    SUBSTR(u.user_name, 1, INSTR(u.user_name, ' ') - 1) AS user_name,
                    ROW_NUMBER() OVER (ORDER BY s.order# NULLS LAST)    AS r#,
                    ROW_NUMBER() OVER (PARTITION BY s.col_order# ORDER BY s.row_order# NULLS LAST) AS row#,
                    GREATEST(COUNT(s.row_order#) OVER (PARTITION BY s.col_order#), 1) AS row_count
                    --
                FROM tsk_lov_statuses_v s
                LEFT JOIN app_users_v u
                    ON u.user_id = in_owner_id
                LEFT JOIN (
                    SELECT
                        t.status_id,
                        COUNT(DISTINCT t.card_id)       AS count_cards,
                        COUNT(NVL(l.checklist_id, 1))   AS count_checks,
                        COUNT(l.checklist_done)         AS count_done
                        --
                    FROM tsk_p100_cards_v t
                    LEFT JOIN tsk_card_checklist l
                        ON l.card_id        = t.card_id
                    WHERE t.client_id       = in_client_id
                        AND t.project_id    = in_project_id
                        AND t.board_id      = in_board_id
                        AND t.swimlane_id   = w.swimlane_id
                    GROUP BY t.status_id
                ) d
                    ON d.status_id = s.status_id
                ORDER BY s.order#
            ) LOOP
                -- generate status header
                clob_append(out_clob,
                    CASE WHEN s.row# = 1 THEN
                        '<div class="COLUMN">'
                    END ||
                    --
                    '<div class="COLUMN_PAYLOAD">' ||
                    '<div class="TARGET_HEADER">' ||
                    '<h3>' || s.status_name ||
                    CASE WHEN s.count_cards > 0 THEN '<span class="BADGE' || CASE WHEN s.is_badge IS NULL THEN ' DECENT' END || '">' || s.count_cards || '</span>' END ||
                    CASE WHEN s.count_cards > 0 THEN '<span class="PROGRESS">' || s.count_done || '/' || s.count_checks || '</span>' END ||
                    '<a href="' ||
                    APEX_PAGE.GET_URL (
                        p_page          => 105,
                        p_clear_cache   => 105,
                        p_items         => 'P105_STATUS_REQUESTED',
                        p_values        => s.status_id
                    ) ||
                    '" class="PLUS"><span class="fa fa-plus"></span></a>' ||
                    '</h3>' ||
                    '<div class="PROGRESS_BAR"><div style="width: ' || NVL(FLOOR(s.count_done / NULLIF(s.count_checks, 0) * 100), 0) || '%;"></div></div>' ||
                    '</div>'  -- .TARGET_HEADER
                );

                -- generate status content/cards
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
                        CASE WHEN w.is_simple IS NULL
                            THEN '<span class="CARD_ID">' || NVL(t.card_number, c_card_prefix || t.card_id) || '</span>' ||
                                '<span style="color: #888;"> &' || 'ndash; </span>'
                            END ||
                        t.card_name ||
                        '</a></div>'
                    );
                END LOOP;
                --
                clob_append(out_clob,
                    '</div>' ||     -- .TARGET
                    '</div>' ||     -- .COLUMN_PAYLOAD
                    --
                    CASE WHEN s.row# = s.row_count THEN
                        '</div>'    -- .COLUMN
                    END
                );
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
            --HTP.P('Card ' || c_card_prefix || APEX_APPLICATION.G_X01 || ' updated');
            HTP.P('{"message":"Card ' || c_card_prefix || APEX_APPLICATION.G_X01 || ' updated","action":"REFRESH_GRID"}');
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

