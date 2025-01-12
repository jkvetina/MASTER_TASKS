CREATE OR REPLACE PACKAGE tsk_nav AS

    FUNCTION get_card_link (
        in_card_id          tsk_cards.card_id%TYPE,
        in_external         CHAR                        := NULL
    )
    RETURN VARCHAR2;

END;
/

