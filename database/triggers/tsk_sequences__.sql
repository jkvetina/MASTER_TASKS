CREATE OR REPLACE TRIGGER tsk_sequences__
FOR UPDATE OR INSERT OR DELETE ON tsk_sequences
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_SEQUENCES';



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            :NEW.updated_by := core.get_user_id();
            :NEW.updated_at := SYSDATE;

            -- check sequence name
            IF NOT REGEXP_LIKE(:NEW.sequence_id, '^[A-Za-z0-9_-]{1,32}$') THEN
                core.raise_error('WRONG_SEQUENCE', :NEW.sequence_id);
            END IF;
        END IF;
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error(c_table_name || '_UPSERT_FAILED');
    END BEFORE EACH ROW;

END;
/

