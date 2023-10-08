CREATE OR REPLACE PACKAGE BODY tsk_nav AS

    FUNCTION get_home
    RETURN VARCHAR2             -- 32k limit!
    AS
        o VARCHAR2(32767);
    BEGIN
        o := o || '<a href="#" style="height: 3rem; padding-top: 1rem !important; padding-right: 1rem;"><span class="fa fa-heart-o"></span> &' || 'nbsp; <span style="">Favorites</span></a>';
        --
        FOR c IN (
            SELECT DISTINCT
                c.client_id,
                c.client_name
            FROM tsk_available_boards_v c
        ) LOOP
            o := o || tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || c.client_name || '</span>', c.client_id);
            --
            FOR p IN (
                SELECT DISTINCT
                    p.project_name,
                    p.client_id,
                    p.project_id
                FROM tsk_available_boards_v p
                WHERE p.client_id = c.client_id
            ) LOOP
                o := o || tsk_app.get_link('<span style="padding-left: 2.4rem; padding-right: 1rem; font-size: 0.85rem;">&' || 'mdash;&' || 'nbsp; ' || p.project_name || '</span>', p.client_id, p.project_id);
            END LOOP;
        END LOOP;
        --
        RETURN
            '<div class="COL_1">' || o || '</div>' ||
            '<div class="COL_2 NO_HOVER" style="padding-left: 2rem; padding-right: 1rem;"><a href="#" style="height: 3rem; padding-top: 1rem !important;"><span class="fa fa-search"></span>&' || 'nbsp; <span style="">Search for Cards</span></a><span style="padding: 0 0.5rem; margin-right: 1rem;"><input id="MENU_SEARCH" value="" /></span></div>';
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
        o := o || '<a href="#" style="height: 3rem; padding-top: 1rem !important; padding-right: 1rem;"><span class="fa fa-filter"></span> &' || 'nbsp; <span>Filters</span></a>';
        --
        FOR c IN (
            SELECT DISTINCT
                c.client_id,
                c.client_name
            FROM tsk_available_clients_v c
            --
            -- @TODO: 1 column per client
            --
        ) LOOP
            o := o || tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || c.client_name || '</span>', c.client_id);
            --
            FOR p IN (
                SELECT DISTINCT
                    p.project_id,
                    p.project_name
                FROM tsk_available_projects_v p
                WHERE p.client_id       = c.client_id
            ) LOOP
                o := o || tsk_app.get_link('<span style="padding-left: 2.4rem; padding-right: 1rem; font-size: 0.85rem;">&' || 'mdash;&' || 'nbsp; ' || p.project_name || '</span>', c.client_id, p.project_id);
            END LOOP;
        END LOOP;

        -- add setup links
        RETURN
            '<div class="COL_1">' || o || '</div>' ||
            '<div class="COL_2">' ||
                '<a href="#" style="height: 3rem; padding-top: 1rem !important; padding-right: 1rem;"><span class="fa fa-abacus"></span> &' || 'nbsp; <span>Setup</span></a>' ||
                tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || 'Projects' || '</span>', NULL) ||
                tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || 'Repositories' || '</span>', NULL) ||
                tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || 'Sequences' || '</span>', NULL) ||
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
        o := o || '<a href="#" style="height: 3rem; padding-top: 1rem !important;"><span class="fa fa-filter"></span> &' || 'nbsp; <span>Filters</span></a>';
        --
        FOR p IN (
            SELECT DISTINCT
                p.client_id,
                p.project_id,
                p.project_name
            FROM tsk_available_boards_v p
            WHERE p.client_id = tsk_app.get_client_id()
            --
            -- @TODO: 1 column per project
            --
        ) LOOP
            o := o || tsk_app.get_link('<span style="padding-left: 1.2rem;">&' || 'mdash;&' || 'nbsp; ' || p.project_name || '</span>', p.client_id, p.project_id);
            --
            FOR b IN (
                SELECT b.*
                FROM tsk_available_boards_v b
                WHERE b.client_id       = p.client_id
                    AND b.project_id    = p.project_id
            ) LOOP
                o := o || tsk_app.get_link('<span style="padding-left: 2.4rem; font-size: 0.85rem;">&' || 'mdash;&' || 'nbsp; ' || b.board_name || '</span>', b.client_id, b.project_id, b.board_id);
            END LOOP;
        END LOOP;

        -- add setup links
        RETURN
            '<div class="COL_1">' || o || '</div>' ||
            '<div class="COL_2">' ||
                '<a href="#" style="height: 3rem; padding-top: 1rem !important; padding-right: 1rem;"><span class="fa fa-abacus"></span> &' || 'nbsp; <span>Setup</span></a>' ||
                tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || 'Boards' || '</span>', NULL) ||
                tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || 'Swimlanes' || '</span>', NULL) ||
                tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || 'Statuses' || '</span>', NULL) ||
                tsk_app.get_link('<span style="padding-left: 1.2rem; padding-right: 1rem;">&' || 'mdash;&' || 'nbsp; ' || 'Categories' || '</span>', NULL) ||
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

