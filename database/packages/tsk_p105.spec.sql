CREATE OR REPLACE PACKAGE tsk_p105 AS

    PROCEDURE init_defaults;



    PROCEDURE save_card;



    PROCEDURE delete_card (
        in_card_id          tsk_cards.card_id%TYPE
    );



    FUNCTION duplicate_card (
        in_card_id          tsk_cards.card_id%TYPE
    )
    RETURN tsk_cards.card_id%TYPE;



    PROCEDURE move_card_to_top (
        in_card_id          tsk_cards.card_id%TYPE
    );



    PROCEDURE save_checklist;



    FUNCTION get_badge_icon (
        in_value            NUMBER
    )
    RETURN VARCHAR2;



    PROCEDURE upsert_comment (
        in_card_id          tsk_card_comments.card_id%TYPE,
        in_comment_id       tsk_card_comments.comment_id%TYPE,
        in_comment_payload  tsk_card_comments.comment_payload%TYPE
    );



    PROCEDURE delete_comment (
        in_card_id          tsk_card_comments.card_id%TYPE,
        in_comment_id       tsk_card_comments.comment_id%TYPE
    );



    FUNCTION split_checklist (
        in_card_id          tsk_cards.card_id%TYPE
    )
    RETURN tsk_cards.card_id%TYPE;



    PROCEDURE merge_checklist (
        in_source_card_id   tsk_cards.card_id%TYPE,
        in_target_card_id   tsk_cards.card_id%TYPE
    );



    PROCEDURE save_attachements;



    PROCEDURE download_attachement (
        in_file_id              tsk_card_files.file_id%TYPE
    );



    PROCEDURE delete_file (
        in_file_id          tsk_card_files.file_id%TYPE
    );

END;
/

