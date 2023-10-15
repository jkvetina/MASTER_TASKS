CREATE OR REPLACE TRIGGER tsk_categories__
FOR UPDATE OR INSERT OR DELETE ON tsk_categories
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_CATEGORIES';
    --
    v_client_id         tsk_categories.client_id%TYPE;
    v_project_id        tsk_categories.project_id%TYPE;
    v_category_id       tsk_categories.category_id%TYPE;



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            IF :NEW.is_default = 'Y' AND :NEW.is_default != NVL(:OLD.is_default, 'N') AND NVL(:NEW.updated_by, '?') != 'STOP' THEN
                v_client_id     := :NEW.client_id;
                v_project_id    := :NEW.project_id;
                v_category_id   := :NEW.category_id;
            END IF;
            --
            :NEW.updated_by := core.get_user_id();
            :NEW.updated_at := SYSDATE;

            -- check category name
            IF NOT REGEXP_LIKE(:NEW.category_id, '^[A-Za-z0-9_-]{1,32}$') THEN
                core.raise_error('WRONG_CATEGORY', :NEW.category_id);
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
        -- make sure every project has exactly one default board
        IF v_category_id IS NOT NULL THEN
            UPDATE tsk_categories t
            SET t.is_default        = NULL
            WHERE t.client_id       = v_client_id
                AND t.project_id    = v_project_id
                AND t.is_default    = 'Y';
            --
            UPDATE tsk_categories t
            SET t.is_default        = 'Y',
                t.updated_by        = 'STOP'        -- a hacky way how to stop recursion
            WHERE t.client_id       = v_client_id
                AND t.project_id    = v_project_id
                AND t.category_id   = v_category_id;
        END IF;
        --
    EXCEPTION
    WHEN core.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        core.raise_error(c_table_name || '_FOLLOWUP_FAILED');
    END AFTER STATEMENT;

END;
/

