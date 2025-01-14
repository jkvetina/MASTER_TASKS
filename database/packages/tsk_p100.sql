CREATE OR REPLACE PACKAGE BODY tsk_p100 AS

    PROCEDURE init_defaults
    AS
        v_card_id           tsk_cards.card_id%TYPE;
    BEGIN
        -- load last project/board on login
        NULL;

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
            WHERE b.board_id = core.get_number_item('P0_BOARD_ID')
        ) LOOP
            core.set_item('P100_HEADER',            'Cards on ' || b.board_name);
            core.set_item('P100_IS_FAVORITE',       b.is_favorite);
            core.set_item('P100_BOOKMARK_ICON',     'fa-bookmark' || CASE WHEN b.is_favorite IS NULL THEN '-o' END);
        END LOOP;

        -- disable buttons
        IF core.get_item('P100_SHOW') IS NULL THEN
            core.set_item('P100_SHOW', 'COLUMNS');
        END IF;
        --
        core.set_item('P100_DISABLE_COLUMNS',   CASE WHEN core.get_item('P100_SHOW') = 'COLUMNS'    THEN 'disabled="disabled"' END);
        core.set_item('P100_DISABLE_LIST',      CASE WHEN core.get_item('P100_SHOW') = 'LIST'       THEN 'disabled="disabled"' END);
        core.set_item('P100_DISABLE_CARDS',     CASE WHEN core.get_item('P100_SHOW') = 'CARDS'      THEN 'disabled="disabled"' END);
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
        in_client_id        CONSTANT tsk_cards.client_id%TYPE       := core.get_number_item('P0_CLIENT_ID');
        in_project_id       CONSTANT tsk_cards.project_id%TYPE      := core.get_number_item('P0_PROJECT_ID');
        in_board_id         CONSTANT tsk_cards.board_id%TYPE        := core.get_number_item('P0_BOARD_ID');
        in_milestone_id     CONSTANT tsk_cards.milestone_id%TYPE    := core.get_number_item('P0_MILESTONE_ID');
        in_owner_id         CONSTANT tsk_cards.owner_id%TYPE        := core.get_number_item('P0_OWNER_ID');
        --
        v_statuses          PLS_INTEGER;
        v_milestones        PLS_INTEGER;
        out_clob            CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(out_clob, cache => TRUE);

        -- calculate number of columns
        SELECT COUNT(s.status_id)
        INTO v_statuses
        FROM tsk_statuses s
        WHERE s.client_id       = in_client_id
            AND s.project_id    = in_project_id
            AND (s.row_order#   IS NULL OR s.row_order# = 1)
            AND s.is_active     = 'Y';

        -- calculate number of milestones
        SELECT COUNT(w.milestone_id)
        INTO v_milestones
        FROM tsk_milestones w
        WHERE w.client_id       = in_client_id
            AND w.project_id    = in_project_id
            AND (w.milestone_id = in_milestone_id OR in_milestone_id IS NULL)
            AND w.is_active     = 'Y';

        -- generate grid
        clob_append(out_clob,
            '<div class="BOARD" style="' ||
            'grid-template-columns: ' || CASE WHEN v_milestones > 1 THEN '0 ' END || 'repeat(' || v_statuses || ', minmax(320px, 1fr));' ||
            '">');
        --
        FOR w IN (
            SELECT
                w.milestone_id,
                w.milestone_name,
                ROW_NUMBER() OVER (ORDER BY CASE WHEN w.milestone_id = '-' THEN NULL ELSE w.order# END NULLS LAST) AS r#,
                COUNT(w.milestone_id) OVER() AS milestones,
                b.is_simple
            FROM tsk_milestones w
            LEFT JOIN tsk_boards b
                ON b.client_id      = in_client_id
                AND b.board_id      = in_board_id
            WHERE w.client_id       = in_client_id
                AND w.project_id    = in_project_id
                AND (w.milestone_id = in_milestone_id OR in_milestone_id IS NULL)
                AND w.is_active     = 'Y'
            ORDER BY r#
        ) LOOP
            -- add milestone name
            IF v_milestones > 1 THEN
                clob_append(out_clob, '<div class="milestone" id="milestone_' || w.milestone_id || '"><span>' || w.milestone_name || '</span></div>');
            END IF;

            -- create status columns (card holders) for each milestones
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
                    ROW_NUMBER() OVER (ORDER BY s.order# NULLS LAST)    AS r#,
                    ROW_NUMBER() OVER (PARTITION BY s.col_order# ORDER BY s.row_order# NULLS LAST) AS row#,
                    GREATEST(COUNT(s.row_order#) OVER (PARTITION BY s.col_order#), 1) AS row_count
                    --
                FROM tsk_lov_statuses_v s
                LEFT JOIN app_users_vpd_v u
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
                        AND t.milestone_id  = w.milestone_id
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
                clob_append(out_clob, '<div class="TARGET" id="STATUS_' || s.status_id || '_MILESTONE_' || w.milestone_id || '">');
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
                        AND t.milestone_id  = w.milestone_id
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
            t.milestone_id  = APEX_APPLICATION.G_X03
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
        rec.client_id       := core.get_number_item('P0_CLIENT_ID');
        rec.project_id      := core.get_number_item('P0_PROJECT_ID');
        rec.board_id        := core.get_number_item('P0_BOARD_ID');
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

