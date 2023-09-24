CREATE OR REPLACE TRIGGER tsk_projects__
FOR UPDATE OR INSERT OR DELETE ON tsk_projects
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_PROJECTS';
    --
    v_client_id         tsk_projects.client_id%TYPE;
    v_project_id        tsk_projects.project_id%TYPE;



    BEFORE EACH ROW IS
    BEGIN
        -- populate audit columns
        IF NOT DELETING THEN
            :NEW.updated_by := core.get_user_id();
            :NEW.updated_at := SYSDATE;
            --
            IF :NEW.is_default = 'Y' THEN
                v_client_id     := :NEW.client_id;
                v_project_id    := :NEW.project_id;
            END IF;
            --
        ELSE
            IF :OLD.is_default = 'Y' THEN
                v_client_id     := :OLD.client_id;
                v_project_id    := :OLD.project_id;
            END IF;
            --
        END IF;
        --
        IF INSERTING THEN
            :NEW.is_active := 'Y';
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
        -- make sure every client has exactly one default project
        IF v_project_id IS NOT NULL THEN
            UPDATE tsk_projects t
            SET t.is_default        = NULL
            WHERE t.client_id       = v_client_id
                AND t.is_default    = 'Y';
            --
            UPDATE tsk_projects t
            SET t.is_default        = 'Y'
            WHERE t.client_id       = v_client_id
                AND t.project_id    = v_project_id;
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

