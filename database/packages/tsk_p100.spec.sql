CREATE OR REPLACE PACKAGE tsk_p100 AS

    c_card_prefix           CONSTANT VARCHAR2(8) := '#';



    PROCEDURE init_defaults;



    FUNCTION generate_board
    RETURN CLOB;



    PROCEDURE ajax_update_card_on_drag;



    PROCEDURE add_to_favorites;



    PROCEDURE remove_from_favorites;

END;
/

