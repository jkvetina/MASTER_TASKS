CREATE OR REPLACE PACKAGE BODY tsk_nav AS

    FUNCTION get_link (
        in_content          VARCHAR2,
        in_page_id          NUMBER                          := NULL,
        in_card_id          tsk_cards.card_id%TYPE          := NULL,
        in_client_id        tsk_recent.client_id%TYPE       := NULL,
        in_project_id       tsk_recent.project_id%TYPE      := NULL,
        in_board_id         tsk_recent.board_id%TYPE        := NULL,
        in_swimlane_id      tsk_recent.swimlane_id%TYPE     := NULL,
        in_status_id        tsk_recent.status_id%TYPE       := NULL,
        in_category_id      tsk_recent.category_id%TYPE     := NULL,
        in_owner_id         tsk_recent.owner_id%TYPE        := NULL,
        in_items            VARCHAR2                        := NULL,
        in_values           VARCHAR2                        := NULL,
        in_class            VARCHAR2                        := NULL,
        in_icon_name        VARCHAR2                        := NULL,
        in_badge            VARCHAR2                        := NULL
    )
    RETURN VARCHAR2
    AS
        v_items             VARCHAR2(32767);
        v_values            VARCHAR2(32767);
        v_icon              VARCHAR2(32767);
    BEGIN
        -- switch context
        IF in_client_id     IS NOT NULL THEN v_items := v_items || ',P0_CLIENT_ID';     v_values := v_values || ',' || in_client_id;    END IF;
        IF in_project_id    IS NOT NULL THEN v_items := v_items || ',P0_PROJECT_ID';    v_values := v_values || ',' || in_project_id;   END IF;
        IF in_board_id      IS NOT NULL THEN v_items := v_items || ',P0_BOARD_ID';      v_values := v_values || ',' || in_board_id;     END IF;
        IF in_swimlane_id   IS NOT NULL THEN v_items := v_items || ',P0_SWIMLANE_ID';   v_values := v_values || ',' || NULLIF(in_swimlane_id, '-'); END IF;
        IF in_status_id     IS NOT NULL THEN v_items := v_items || ',P0_STATUS_ID';     v_values := v_values || ',' || NULLIF(in_status_id,   '-'); END IF;
        IF in_category_id   IS NOT NULL THEN v_items := v_items || ',P0_CATEGORY_ID';   v_values := v_values || ',' || NULLIF(in_category_id, '-'); END IF;
        IF in_owner_id      IS NOT NULL THEN v_items := v_items || ',P0_OWNER_ID';      v_values := v_values || ',' || NULLIF(in_owner_id,    '-'); END IF;

        -- adjust icons
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
                p_clear_cache   => CASE WHEN (in_project_id IS NOT NULL OR in_client_id IS NOT NULL) THEN '0,' || COALESCE(in_page_id, core.get_page_id()) END,
                p_items         => SUBSTR(v_items,  2, 4000),
                p_values        => SUBSTR(v_values, 2, 4000)
            ) ||
            '" class="' || in_class || '">' || v_icon || in_content ||
            CASE WHEN in_badge IS NOT NULL THEN '</span><span class="BADGE DECENT">' || in_badge END ||
            '</span></a>';
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_card_link (
        in_card_id          tsk_cards.card_id%TYPE,
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
                    p_items             => 'P100_CARD_ID',
                    p_values            => in_card_id,
                    p_plain_url         => TRUE
                );
        END IF;
        --
        FOR c IN (
            SELECT
                t.card_id,
                t.client_id,
                t.project_id,
                t.board_id
            FROM tsk_cards t
            WHERE t.card_id = in_card_id
        ) LOOP
            RETURN APEX_PAGE.GET_URL (
                p_page              => 105,
                p_clear_cache       => 105,
                p_items             => 'P105_CARD_ID',
                p_values            => c.card_id
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
                    in_class        => 'M4' || REPLACE(b.is_current, 'Y', ' ACTIVE'),
                    in_icon_name    => CASE WHEN b.is_current = 'Y' THEN 'fa-arrow-circle-right' END
                );
            END IF;
        END LOOP;
        --
        o := o || '</div>';
        o := o || '<div>';      -- class=ROW

        -- add recent tasks
        /*
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
            FETCH FIRST 1 ROWS ONLY
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
        */
        --
        o := o || '</div>';

        -- add extra pages
        o := '<div>' || o || '</div>' ||
            '<div>' ||
                '<div class="M1"><span class="fa fa-alarm-clock"></span> &' || 'nbsp; <span>Recent Tasks</span></div>' ||
                '<div>' ||
                r ||
                '</div>' ||
            '</div>' ||
            '<div class="NO_HOVER" style="padding-left: 2rem; padding-right: 1rem;"><a href="#" style="height: 3rem; padding-top: 1rem !important;"><span class="fa fa-search"></span>&' || 'nbsp; <span style="">Search for Cards</span></a><span style="padding: 0 0.5rem; margin-right: 1rem;"><input id="MENU_SEARCH" value="" /></span></div>';
        --
        IF LENGTH(o) >= 3900 THEN
            core.raise_error('4K_LIMIT_EXCEEDED');
        END IF;
        --
        RETURN o;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_swimlanes
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_project_id() IS NULL THEN
            RETURN NULL;
        END IF;
        --
        o := o || '<div class="M1"><span class="fa fa-chevron-down"></span> &' || 'nbsp; <span>Select Swimlane</span></div>';
        o := o || get_link (
            in_content      => 'All Swimlanes',
            in_swimlane_id  => '-',
            in_class        => 'M2' || CASE WHEN tsk_app.get_swimlane_id() IS NULL THEN ' ACTIVE' END,
            in_icon_name    => CASE WHEN tsk_app.get_swimlane_id() IS NULL THEN 'fa-arrow-circle-right' END
        );
        --
        --
        FOR t IN (
            SELECT
                t.swimlane_id,
                t.swimlane_name,
                CASE WHEN t.swimlane_id = tsk_app.get_swimlane_id() THEN 'Y' END AS is_current
            FROM tsk_lov_swimlanes_v t
            ORDER BY t.order#
        ) LOOP
            o := o || get_link (
                in_content      => t.swimlane_name,
                in_swimlane_id  => t.swimlane_id,
                in_class        => 'M2' || REPLACE(t.is_current, 'Y', ' ACTIVE'),
                in_icon_name    => CASE WHEN t.is_current = 'Y' THEN 'fa-arrow-circle-right' END
            );
        END LOOP;
        --
        o := '<div>' || o || '</div>';
        --
        IF LENGTH(o) >= 3900 THEN
            core.raise_error('4K_LIMIT_EXCEEDED');
        END IF;
        --
        RETURN o;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_statuses
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_project_id() IS NULL THEN
            RETURN NULL;
        END IF;
        --
        o := o || '<div class="M1"><span class="fa fa-chevron-down"></span> &' || 'nbsp; <span>Select Status</span></div>';
        o := o || get_link (
            in_content      => 'All Statuses',
            in_status_id    => '-',
            in_class        => 'M2' || CASE WHEN tsk_app.get_status_id() IS NULL THEN ' ACTIVE' END,
            in_icon_name    => CASE WHEN tsk_app.get_status_id() IS NULL THEN 'fa-arrow-circle-right' END
        );
        --
        FOR t IN (
            SELECT
                t.status_id,
                t.status_name,
                CASE WHEN t.status_id = tsk_app.get_status_id() THEN 'Y' END AS is_current
            FROM tsk_lov_statuses_v t
            ORDER BY t.order#
        ) LOOP
            o := o || get_link (
                in_content      => t.status_name,
                in_status_id    => t.status_id,
                in_class        => 'M2' || REPLACE(t.is_current, 'Y', ' ACTIVE'),
                in_icon_name    => CASE WHEN t.is_current = 'Y' THEN 'fa-arrow-circle-right' END
            );
        END LOOP;
        --
        o := '<div>' || o || '</div>';
        --
        IF LENGTH(o) >= 3900 THEN
            core.raise_error('4K_LIMIT_EXCEEDED');
        END IF;
        --
        RETURN o;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_categories
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_project_id() IS NULL THEN
            RETURN NULL;
        END IF;
        --
        o := o || '<div class="M1"><span class="fa fa-chevron-down"></span> &' || 'nbsp; <span>Select Category</span></div>';
        o := o || get_link (
            in_content      => 'All Categories',
            in_category_id  => '-',
            in_class        => 'M2' || CASE WHEN tsk_app.get_category_id() IS NULL THEN ' ACTIVE' END,
            in_icon_name    => CASE WHEN tsk_app.get_category_id() IS NULL THEN 'fa-arrow-circle-right' END
        );
        o := o || get_link (
            in_content      => 'Empty Category',
            in_category_id  => '!',
            in_class        => 'M2' || CASE WHEN tsk_app.get_category_id() = '!' THEN ' ACTIVE' END,
            in_icon_name    => CASE WHEN tsk_app.get_category_id() = '!' THEN 'fa-arrow-circle-right' END
        );
        --
        FOR g IN (
            SELECT DISTINCT
                t.category_group
            FROM tsk_lov_categories_v t
            ORDER BY 1
        ) LOOP
            o := o || get_link (
                in_content      => g.category_group,
                in_category_id  => 'G:' || g.category_group,
                in_class        => 'M2',
                in_icon_name    => NULL
            );
            --
            FOR t IN (
                SELECT
                    t.category_id,
                    t.category_name,
                    CASE WHEN t.category_id = tsk_app.get_category_id() THEN 'Y' END AS is_current
                FROM tsk_lov_categories_v t
                WHERE t.category_group = g.category_group
                ORDER BY t.order#
            ) LOOP
                o := o || get_link (
                    in_content      => t.category_name,
                    in_category_id  => t.category_id,
                    in_class        => 'M3' || REPLACE(t.is_current, 'Y', ' ACTIVE'),
                    in_icon_name    => CASE WHEN t.is_current = 'Y' THEN 'fa-arrow-circle-right' END
                );
            END LOOP;
        END LOOP;
        --
        o := '<div>' || o || '</div>';
        --
        IF LENGTH(o) >= 3900 THEN
            core.raise_error('4K_LIMIT_EXCEEDED');
        END IF;
        --
        RETURN o;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error();
    END;



    FUNCTION get_owners
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_project_id() IS NULL THEN
            RETURN NULL;
        END IF;
        --
        o := o || '<div class="M1"><span class="fa fa-chevron-down"></span> &' || 'nbsp; <span>Select Owner</span></div>';
        o := o || get_link (
            in_content      => 'All Owners',
            in_owner_id     => '-',
            in_class        => 'M2' || CASE WHEN tsk_app.get_owner_id() IS NULL THEN ' ACTIVE' END,
            in_icon_name    => CASE WHEN tsk_app.get_owner_id() IS NULL THEN 'fa-arrow-circle-right' END
        );
        --
        FOR t IN (
            SELECT DISTINCT
                t.owner_id,
                CASE WHEN t.owner_id = tsk_app.get_owner_id() THEN 'Y' END AS is_current
            FROM tsk_p100_cards_v t
            ORDER BY t.owner_id
        ) LOOP
            o := o || get_link (
                in_content      => t.owner_id,
                in_owner_id     => t.owner_id,
                in_class        => 'M2' || REPLACE(t.is_current, 'Y', ' ACTIVE'),
                in_icon_name    => CASE WHEN t.is_current = 'Y' THEN 'fa-arrow-circle-right' END
            );
        END LOOP;
        --
        o := '<div>' || o || '</div>';
        --
        IF LENGTH(o) >= 3900 THEN
            core.raise_error('4K_LIMIT_EXCEEDED');
        END IF;
        --
        RETURN o;
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

