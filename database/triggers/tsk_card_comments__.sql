CREATE OR REPLACE TRIGGER tsk_card_comments__
FOR UPDATE OR INSERT OR DELETE ON tsk_card_comments
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_CARD_COMMENTS';



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            IF :NEW.comment_id IS NULL THEN
                :NEW.comment_id := tsk_comment_id.NEXTVAL;
            END IF;
            --
            IF (UPDATING OR (INSERTING AND :NEW.updated_at IS NULL)) THEN
                :NEW.updated_by := core.get_user_id();
                :NEW.updated_at := SYSDATE;
            END IF;
        END IF;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error(c_table_name || '_UPSERT_FAILED');
    END BEFORE EACH ROW;



    AFTER STATEMENT IS
    BEGIN
        NULL;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error(c_table_name || '_FOLLOWUP_FAILED');
    END AFTER STATEMENT;

END;
/

