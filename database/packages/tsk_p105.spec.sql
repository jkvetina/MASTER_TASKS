CREATE OR REPLACE PACKAGE tsk_p105 AS

    PROCEDURE init_defaults;



    PROCEDURE save_card;



    PROCEDURE save_checklist;



    FUNCTION get_badge_icon (
        in_value            NUMBER
    )
    RETURN VARCHAR2;



    PROCEDURE save_comment;



    PROCEDURE ajax_delete_comment;



    PROCEDURE save_split_checklist;



    PROCEDURE save_merge_checklist;



    PROCEDURE save_attachements;



    PROCEDURE download_attachement (
        in_file_id              tsk_card_files.file_id%TYPE
    );



    PROCEDURE move_card_to_top;

END;
/

