CREATE OR REPLACE TRIGGER tsk_card_commits__
FOR UPDATE OR INSERT OR DELETE ON tsk_card_commits
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_CARD_COMMITS';



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            :NEW.updated_by := core.get_user_id();
            :NEW.updated_at := SYSDATE;
        END IF;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error(c_table_name || '_UPSERT_FAILED');
    END BEFORE EACH ROW;

END;
/

