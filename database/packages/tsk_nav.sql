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
        in_badge            VARCHAR2                        := NULL,
        in_current          CHAR                            := NULL
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
            '" class="' || in_class ||
            CASE WHEN in_current = 'Y' THEN ' ACTIVE' END ||
            '">' || v_icon ||
            CASE WHEN in_current = 'Y' THEN core.get_icon('fa-arrow-circle-right') || ' &' || 'nbsp; ' END ||
            in_content ||
            CASE WHEN in_badge IS NOT NULL THEN ' <span class="BADGE DECENT">' || in_badge || '</span>' END ||
            '</a>';
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



    FUNCTION get_switch_client
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        FOR c IN (
            SELECT
                tsk_nav.get_link (
                    in_content      => a.client_name,
                    in_page_id      => core.get_page_id(),
                    in_client_id    => a.client_id,
                    in_current      => a.is_current
                ) AS row_
                --
            FROM tsk_available_clients_v a
            ORDER BY a.order#
        ) LOOP
            o := o || '<li>' || c.row_ || '</li>';
        END LOOP;
        --
        RETURN '<div class="ACTION_MENU" data-id="SWITCH_CLIENT"><div class="WRAPPER"><div class="CONTENT"><ul role="menu">' || o || '</ul></div></div></div>';
    END;



    FUNCTION get_switch_project
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        FOR c IN (
            SELECT
                tsk_nav.get_link (
                    in_content      => a.project_name,
                    in_page_id      => core.get_page_id(),
                    in_client_id    => a.client_id,
                    in_project_id   => a.project_id,
                    in_current      => a.is_current
                ) AS row_
                --
            FROM tsk_available_projects_v a
            WHERE a.is_current_client = 'Y'
            ORDER BY a.order#
        ) LOOP
            o := o || '<li>' || c.row_ || '</li>';
        END LOOP;
        --
        RETURN '<div class="ACTION_MENU" data-id="SWITCH_PROJECT"><div class="WRAPPER"><div class="CONTENT"><ul role="menu">' || o || '</ul></div></div></div>';
    END;



    FUNCTION get_switch_board
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        FOR c IN (
            SELECT
                tsk_nav.get_link (
                    in_content      => a.board_name,
                    in_page_id      => core.get_page_id(),
                    in_client_id    => a.client_id,
                    in_project_id   => a.project_id,
                    in_board_id     => a.board_id,
                    in_current      => a.is_current
                ) AS row_
                --
            FROM tsk_available_boards_v a
            WHERE a.is_current_project = 'Y'
            ORDER BY a.board_order#
        ) LOOP
            o := o || '<li>' || c.row_ || '</li>';
        END LOOP;
        --
        RETURN '<div class="ACTION_MENU" data-id="SWITCH_BOARD"><div class="WRAPPER"><div class="CONTENT"><ul role="menu">' || o || '</ul></div></div></div>';
    END;



    FUNCTION get_switch_swimlane
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_swimlane_id() IS NOT NULL THEN
            o := o || '<li>' ||
                tsk_nav.get_link (
                    in_content      => 'All',
                    in_page_id      => core.get_page_id(),
                    in_swimlane_id  => '-',
                    in_current      => 'Y'
                ) ||
                '</li>';
        END IF;
        --
        FOR c IN (
            SELECT
                tsk_nav.get_link (
                    in_content      => a.swimlane_name,
                    in_page_id      => core.get_page_id(),
                    in_swimlane_id  => a.swimlane_id,
                    in_current      => a.is_current
                ) AS row_
                --
            FROM tsk_lov_swimlanes_v a
            ORDER BY a.order#
        ) LOOP
            o := o || '<li>' || c.row_ || '</li>';
        END LOOP;
        --
        RETURN '<div class="ACTION_MENU" data-id="SWITCH_SWIMLANE"><div class="WRAPPER"><div class="CONTENT"><ul role="menu">' || o || '</ul></div></div></div>';
    END;



    FUNCTION get_switch_status
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_status_id() IS NOT NULL THEN
            o := o || '<li>' ||
                tsk_nav.get_link (
                    in_content      => 'All',
                    in_page_id      => core.get_page_id(),
                    in_status_id    => '-',
                    in_current      => 'Y'
                ) ||
                '</li>';
        END IF;
        --
        FOR c IN (
            SELECT
                tsk_nav.get_link (
                    in_content      => a.status_name,
                    in_page_id      => core.get_page_id(),
                    in_status_id    => a.status_id,
                    in_current      => a.is_current
                ) AS row_,
                --
                CASE WHEN a.status_group != LAG(a.status_group) OVER (ORDER BY a.order#)        THEN 'Y' END AS is_new_column,
                CASE WHEN ROW_NUMBER() OVER (PARTITION BY a.status_group ORDER BY a.order#) = 1 THEN 'Y' END AS is_first_column
                --
            FROM tsk_lov_statuses_v a
            ORDER BY a.order#
        ) LOOP
            IF c.is_new_column = 'Y' THEN
                o := o || '</ul><ul role="menu">';
            END IF;
            --
            o := o || '<li>' || c.row_ || '</li>';
        END LOOP;
        --
        RETURN '<div class="ACTION_MENU" data-id="SWITCH_STATUS"><div class="WRAPPER"><div class="CONTENT"><ul role="menu">' || o || '</ul></div></div></div>';
    END;



    FUNCTION get_switch_category
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_category_id() IS NOT NULL THEN
            o := o || '<li>' ||
            tsk_nav.get_link (
                in_content      => 'All',
                in_page_id      => core.get_page_id(),
                in_category_id  => '-',
                in_current      => 'Y'
            ) ||
            '</li>';
        END IF;
        --
        FOR c IN (
            SELECT
                a.category_name,
                tsk_nav.get_link (
                    in_content      => a.category_name,
                    in_page_id      => core.get_page_id(),
                    in_category_id  => a.category_id,
                    in_current      => a.is_current
                ) AS row_,
                --
                CASE WHEN a.category_group != LAG(a.category_group) OVER (ORDER BY a.order#)        THEN 'Y' END AS is_new_column,
                CASE WHEN ROW_NUMBER() OVER (PARTITION BY a.category_group ORDER BY a.order#) = 1   THEN 'Y' END AS is_first_column
                --
            FROM tsk_lov_categories_v a
            ORDER BY a.order#
        ) LOOP
            IF c.is_new_column = 'Y' THEN
                o := o || '</ul><ul role="menu">';
            END IF;
            --
            IF c.is_first_column = 'Y' THEN
                o := o || '<li><span class="NAV_L2">' || c.category_name || '</span></li>';
            END IF;
            --
            o := o || '<li class="NAV_L3">' || c.row_ || '</li>';
        END LOOP;
        --
        RETURN '<div class="ACTION_MENU" data-id="SWITCH_CATEGORY"><div class="WRAPPER"><div class="CONTENT"><ul role="menu">' || o || '</ul></div></div></div>';
    END;



    FUNCTION get_switch_owner
    RETURN VARCHAR2
    AS
        o VARCHAR2(32767);
    BEGIN
        IF tsk_app.get_owner_id() IS NOT NULL THEN
            o := o || '<li>' ||
                tsk_nav.get_link (
                    in_content      => 'All',
                    in_page_id      => core.get_page_id(),
                    in_owner_id     => '-',
                    in_current      => 'Y'
                ) ||
                '</li>';
        END IF;
        --
        FOR c IN (
            SELECT
                tsk_nav.get_link (
                    in_content      => a.user_name,
                    in_page_id      => core.get_page_id(),
                    in_swimlane_id  => a.user_id,
                    in_current      => a.is_current
                ) AS row_
            FROM tsk_lov_owners_v a
            ORDER BY a.order#
        ) LOOP
            o := o || '<li>' || c.row_ || '</li>';
        END LOOP;
        --
        RETURN '<div class="ACTION_MENU" data-id="SWITCH_OWNER"><div class="WRAPPER"><div class="CONTENT"><ul role="menu">' || o || '</ul></div></div></div>';
    END;

END;
/

