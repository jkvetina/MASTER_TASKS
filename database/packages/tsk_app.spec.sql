CREATE OR REPLACE PACKAGE tsk_app AS

    PROCEDURE init_defaults;



    FUNCTION get_card_next_sequence (
        in_sequence_id      tsk_sequences.sequence_id%TYPE,
        in_client_id        tsk_sequences.client_id%TYPE        := NULL
    )
    RETURN tsk_cards.card_number%TYPE;



    FUNCTION get_card_sequence (
        in_card_number      tsk_cards.card_number%TYPE,
        in_client_id        tsk_cards.client_id%TYPE        := NULL
    )
    RETURN tsk_sequences.sequence_id%TYPE;

END;
/

