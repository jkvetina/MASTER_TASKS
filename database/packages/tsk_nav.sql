CREATE OR REPLACE PACKAGE BODY tsk_nav AS

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

END;
/

