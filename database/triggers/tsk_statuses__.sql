CREATE OR REPLACE TRIGGER tsk_statuses__
FOR UPDATE OR INSERT OR DELETE ON tsk_statuses
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_STATUSES';



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            :NEW.updated_by := core.get_user_id();
            :NEW.updated_at := SYSDATE;

            -- check status name
            IF NOT REGEXP_LIKE(:NEW.status_id, '^[A-Za-z0-9_-]{1,32}$') THEN
                core.raise_error('WRONG_STATUS', :NEW.status_id);
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

