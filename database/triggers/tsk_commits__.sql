CREATE OR REPLACE TRIGGER tsk_commits__
FOR UPDATE OR INSERT OR DELETE ON tsk_commits
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_COMMITS';



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            :NEW.updated_by := core.get_user_id();
            :NEW.updated_at := SYSDATE;
            :NEW.created_by := NVL(:NEW.created_by, :NEW.updated_by);
            :NEW.created_at := NVL(:NEW.created_at, :NEW.updated_at);
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

