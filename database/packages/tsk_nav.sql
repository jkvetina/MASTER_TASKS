CREATE OR REPLACE PACKAGE BODY tsk_nav AS

    FUNCTION get_link (
        in_content          VARCHAR2,
        in_page_id          NUMBER,
        in_card_id          tsk_cards.card_id%TYPE          := NULL,
        in_client_id        tsk_recent.client_id%TYPE       := NULL,
        in_project_id       tsk_recent.project_id%TYPE      := NULL,
        in_board_id         tsk_recent.board_id%TYPE        := NULL,
        in_swimlanes        tsk_recent.swimlanes%TYPE       := NULL,
        in_owners           tsk_recent.owners%TYPE          := NULL,
        in_items            VARCHAR2                        := NULL,
        in_values           VARCHAR2                        := NULL,
        in_class            VARCHAR2                        := NULL,
        in_icon_name        VARCHAR2                        := NULL
    )
    RETURN VARCHAR2
    AS
        v_items             VARCHAR2(32767);
        v_values            VARCHAR2(32767);
        v_icon              VARCHAR2(32767);
    BEGIN
        --
        IF in_client_id IS NOT NULL THEN
            v_items         := v_items  || ',P0_CLIENT_ID';
            v_values        := v_values || ',' || in_client_id;
        END IF;
        --
        IF in_project_id IS NOT NULL THEN
            v_items         := v_items  || ',P0_PROJECT_ID';
            v_values        := v_values || ',' || in_project_id;
        END IF;
        --
        IF in_board_id IS NOT NULL THEN
            v_items         := v_items  || ',P0_BOARD_ID';
            v_values        := v_values || ',' || in_board_id;
        END IF;
        --
        v_icon := CASE
            WHEN in_icon_name IS NOT NULL
                THEN '<span class="fa ' || in_icon_name || '"></span><span> &' || 'nbsp; '
            ELSE '<span>&' || 'mdash;&' || 'nbsp; '
            END;
        --
        RETURN '<a href="' ||
            APEX_PAGE.GET_URL (
                --p_application   =>
                p_page          => COALESCE(in_page_id, core.get_page_id()),
                --p_session       =>
                --p_request       =>
                --p_debug         =>
                p_clear_cache   => COALESCE(in_page_id, core.get_page_id()),
                p_items         => SUBSTR(v_items,  2, 4000),
                p_values        => SUBSTR(v_values, 2, 4000)
            ) ||
            '" class="' || in_class || '">' || v_icon || in_content || '</span></a>';
    END;



    FUNCTION get_home
    RETURN VARCHAR2             -- 32k limit! - well, actually 4k limit on NAV view
    AS
        o VARCHAR2(32767);
        r VARCHAR2(32767);
        --
        last_client     tsk_projects.client_id%TYPE     := '-';
        last_project    tsk_projects.project_id%TYPE    := '-';
    BEGIN
        -- show favorite/bookmarked boards
        o := o || '<div class="M1"><span class="fa fa-heart-o"></span> &' || 'nbsp; <span>Favorites</span></div>';
        o := o || '<div>';      -- class=ROW
        --
        FOR b IN (
            SELECT
                b.client_id,
                b.client_name,
                b.project_id,
                b.project_name,
                b.board_id,
                b.board_name,
                b.is_current,
                --
                COUNT(b.board_id) OVER (PARTITION BY b.client_id, b.project_id) AS boards
                --
            FROM tsk_available_boards_v b
            WHERE b.is_favorite = 'Y'
            ORDER BY b.client_name, b.project_name, b.board_name
        ) LOOP
            -- render client link
            IF b.client_id != last_client THEN
                o := o || get_link (
                    in_content      => b.client_name,
                    in_page_id      => 100,
                    in_client_id    => b.client_id,
                    in_project_id   => NULL,
                    in_board_id     => NULL,
                    in_swimlanes    => NULL,
                    in_owners       => NULL,
                    in_class        => 'M2',
                    in_icon_name    => CASE WHEN b.client_id = tsk_app.get_client_id() THEN 'fa-arrow-circle-right' END
                );
                --
                last_client := b.client_id;
            END IF;

            -- render project link
            IF b.project_id != last_project THEN
                o := o || get_link (
                    in_content      => b.project_name,
                    in_page_id      => 100,
                    in_client_id    => b.client_id,
                    in_project_id   => b.project_id,
                    in_board_id     => NULL,
                    in_swimlanes    => NULL,
                    in_owners       => NULL,
                    in_class        => 'M3' || CASE WHEN b.boards = 1 THEN REPLACE(b.is_current, 'Y', ' ACTIVE') END,
                    in_icon_name    => CASE WHEN b.project_id = tsk_app.get_project_id() THEN 'fa-arrow-circle-right' END
                );
                --
                last_project := b.project_id;
            END IF;

            -- render board link
            IF b.boards > 1 THEN
                o := o || get_link (
                    in_content      => b.board_name,
                    in_page_id      => 100,
                    in_client_id    => b.client_id,
                    in_project_id   => b.project_id,
                    in_board_id     => b.board_id,
                    in_swimlanes    => NULL,
                    in_owners       => NULL,
                    in_class        => 'M4' || REPLACE(b.is_current, 'Y', ' ACTIVE'),
                    in_icon_name    => CASE WHEN b.is_current = 'Y' THEN 'fa-arrow-circle-right' END
                );
            END IF;
        END LOOP;
        --
        o := o || '</div>';
        o := o || '<div>';      -- class=ROW

        -- add recent tasks
        FOR t IN (
            SELECT
                t.client_id,
                t.project_id,
                t.board_id,
                t.card_id,
                t.card_number,
                t.card_name,
                --
                CASE WHEN s.status_id IS NOT NULL
                    THEN ROW_NUMBER() OVER (PARTITION BY t.status_id ORDER BY t.order#)
                    END AS badge
                --
            FROM tsk_p100_cards_v t
            LEFT JOIN tsk_statuses s
                ON s.client_id      = t.client_id
                AND s.project_id    = t.project_id
                AND s.status_id     = t.status_id
                AND s.is_badge      = 'Y'
            WHERE t.owner_id        = core.get_user_id()
            ORDER BY t.updated_at DESC
            FETCH FIRST 10 ROWS ONLY
        ) LOOP
            r := r || get_link (
                in_content      => NVL(t.card_number, '#' || t.card_id) || ' - ' || CASE WHEN LENGTH(t.card_name) > 30 THEN SUBSTR(TRIM(t.card_name), 1, 27) || '...' ELSE t.card_name END,
                in_page_id      => 105,
                in_card_id      => t.card_id,
                in_client_id    => t.client_id,
                in_project_id   => t.project_id,
                in_board_id     => t.board_id,
                in_class        => 'M2',
                in_icon_name    => CASE WHEN t.badge BETWEEN 1 AND 5 THEN 'fa-number-' || t.badge END
            );
        END LOOP;
        --
        o := o || '</div>';

        -- add extra pages
        RETURN
            '<div>' || o || '</div>' ||
            '<div>' ||
                '<div class="M1"><span class="fa fa-alarm-clock"></span> &' || 'nbsp; <span>Recent Tasks</span></div>' ||
                '<div>' ||
                r ||
                '</div>' ||
            '</div>' ||
            '<div class="NO_HOVER" style="padding-left: 2rem; padding-right: 1rem;"><a href="#" style="height: 3rem; padding-top: 1rem !important;"><span class="fa fa-search"></span>&' || 'nbsp; <span style="">Search for Cards</span></a><span style="padding: 0 0.5rem; margin-right: 1rem;"><input id="MENU_SEARCH" value="" /></span></div>';
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_clients
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        o := o || '<div class="M1"><span class="fa fa-chevron-down"></span> &' || 'nbsp; <span>Select Client</span></div>';
        o := o || '<div>';      -- class=ROW
        --
        FOR c IN (
            SELECT DISTINCT
                c.client_id,
                c.client_name,
                c.is_current
            FROM tsk_available_clients_v c
            ORDER BY c.client_name
        ) LOOP
            o := o || tsk_app.get_link (
                CASE WHEN c.is_current = 'Y' THEN '<span class="fa fa-arrow-circle-right"></span><span>' ELSE '<span>&' || 'mdash;' END ||
                '&' || 'nbsp; ' || c.client_name || '</span>',
                c.client_id,
                in_class => 'M2' || REPLACE(c.is_current, 'Y', ' ACTIVE')
            );
            --
            FOR p IN (
                SELECT DISTINCT
                    p.client_id,
                    p.project_id,
                    p.project_name,
                    p.is_current
                FROM tsk_available_projects_v p
                WHERE p.client_id       = c.client_id
                    AND c.is_current    = 'Y'       -- current client
            ) LOOP
                o := o || tsk_app.get_link (
                    CASE WHEN p.is_current = 'Y' THEN '<span class="fa fa-arrow-circle-right"></span><span>' ELSE '<span>&' || 'mdash;' END ||
                    '&' || 'nbsp; ' || p.project_name || '</span>',
                    c.client_id,
                    p.project_id,
                    in_class => 'M3'
                );
            END LOOP;
        END LOOP;
        --
        o := o || '</div>';

        -- add setup links
        IF tsk_app.get_client_id() IS NULL THEN
            RETURN
                '<div>' || o || '</div>';
        END IF;
        --
        RETURN
            '<div>' || o || '</div>' ||
            '<div>' ||
                '<div class="M1"><span class="fa fa-abacus"></span> &' || 'nbsp; <span>Setup</span></div>' ||
                tsk_app.get_page_link(300, '<span>&' || 'mdash;&' || 'nbsp; Projects</span>', 'M2') ||
                tsk_app.get_page_link(510, '<span>&' || 'mdash;&' || 'nbsp; Repositories</span>', 'M2') ||
                tsk_app.get_page_link(210, '<span>&' || 'mdash;&' || 'nbsp; Sequences</span>', 'M2') ||
            '</div>';
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_projects
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_client_id() IS NULL THEN
            RETURN NULL;
        END IF;
        --
        o := o || '<div class="M1"><span class="fa fa-chevron-down"></span> &' || 'nbsp; <span>Select Project</span></div>';
        o := o || '<div>';      -- class=ROW
        --
        FOR p IN (
            SELECT DISTINCT
                p.client_id,
                p.project_id,
                p.project_name,
                p.is_current
            FROM tsk_available_projects_v p
            WHERE p.client_id = tsk_app.get_client_id()
            ORDER BY p.project_name
        ) LOOP
            --o := o || '<div>';
            o := o || tsk_app.get_link (
                CASE WHEN p.is_current = 'Y' THEN '<span class="fa fa-arrow-circle-right"></span><span>' ELSE '<span>&' || 'mdash;' END ||
                '&' || 'nbsp; ' || p.project_name || '</span>',
                p.client_id,
                p.project_id,
                in_class => 'M2' || REPLACE(p.is_current, 'Y', ' ACTIVE')
            );
            --
            FOR b IN (
                SELECT
                    b.client_id,
                    b.project_id,
                    b.board_id,
                    b.board_name,
                    b.is_current
                FROM tsk_available_boards_v b
                WHERE b.client_id       = p.client_id
                    AND b.project_id    = p.project_id
                    AND p.is_current    = 'Y'       -- current project
                ORDER BY b.order#
            ) LOOP
                o := o || tsk_app.get_link (
                    CASE WHEN b.is_current = 'Y' THEN '<span class="fa fa-arrow-circle-right"></span><span>' ELSE '<span>&' || 'mdash;' END ||
                    '&' || 'nbsp; ' || b.board_name || '</span>',
                    b.client_id,
                    b.project_id,
                    b.board_id,
                    in_class => 'M3'
                );
            END LOOP;
            --o := o || '</div>';
        END LOOP;
        --
        o := o || '</div>';

        -- add setup links
        IF tsk_app.get_project_id() IS NULL THEN
            RETURN
                '<div>' || o || '</div>';
        END IF;
        --
        RETURN
            '<div>' || o || '</div>' ||
            '<div>' ||
                '<div class="M1"><span class="fa fa-abacus"></span> &' || 'nbsp; <span>Setup</span></div>' ||
                tsk_app.get_page_link(400, '<span>&' || 'mdash;&' || 'nbsp; Boards</span>', 'M2') ||
                tsk_app.get_page_link(310, '<span>&' || 'mdash;&' || 'nbsp; Swimlanes</span>', 'M2') ||
                tsk_app.get_page_link(320, '<span>&' || 'mdash;&' || 'nbsp; Statuses</span>', 'M2') ||
                tsk_app.get_page_link(340, '<span>&' || 'mdash;&' || 'nbsp; Categories</span>', 'M2') ||
            '</div>';
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_boards
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_project_id() IS NULL THEN
            RETURN NULL;
        END IF;
        --
        o := o || '<div class="M1"><span class="fa fa-chevron-down"></span> &' || 'nbsp; <span>Select Board</span></div>';
        --
        FOR t IN (
            SELECT
                t.client_id,
                t.project_id,
                t.board_id,
                t.board_name,
                t.is_current
            FROM tsk_lov_boards_v t
            ORDER BY t.order#
        ) LOOP
            o := o || tsk_app.get_link (
                CASE WHEN t.is_current = 'Y' THEN '<span class="fa fa-arrow-circle-right"></span><span>' ELSE '<span>&' || 'mdash;' END ||
                '&' || 'nbsp; ' || t.board_name || '</span>',
                t.client_id,
                t.project_id,
                t.board_id,
                in_class => 'M2' || REPLACE(t.is_current, 'Y', ' ACTIVE')
            );
        END LOOP;
        --
        --
        RETURN
            '<div>' || o || '</div>';
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_commits
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        --
        RETURN o;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;

END;
/

