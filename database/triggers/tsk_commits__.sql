CREATE OR REPLACE TRIGGER tsk_commits__
FOR UPDATE OR INSERT OR DELETE ON tsk_commits
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_COMMITS';



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            :NEW.created_by := core.get_user_id();
            :NEW.created_at := SYSDATE;
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

