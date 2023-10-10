CREATE OR REPLACE TRIGGER tsk_cards__
FOR UPDATE OR INSERT OR DELETE ON tsk_cards
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_CARDS';



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            IF :NEW.card_id IS NULL THEN
                :NEW.card_id := tsk_card_id.NEXTVAL;
            END IF;
            --
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

