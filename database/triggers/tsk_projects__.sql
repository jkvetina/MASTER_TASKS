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
            IF :NEW.is_default = 'Y' AND :NEW.is_default != NVL(:OLD.is_default, 'N') AND NVL(:NEW.updated_by, '?') != 'STOP' THEN
                v_client_id     := :NEW.client_id;
                v_project_id    := :NEW.project_id;
            END IF;
            --
            :NEW.updated_by := core.get_user_id();
            :NEW.updated_at := SYSDATE;

            -- check project name
            IF NOT REGEXP_LIKE(:NEW.project_id, '^[A-Za-z0-9_-]{1,32}$') THEN
                core.raise_error('WRONG_PROJECT', :NEW.project_id);
            END IF;
        END IF;
        --
        IF INSERTING THEN
            -- make sure every project has at leats one default board
            BEGIN
                INSERT INTO tsk_boards (board_name, client_id, project_id, is_active, is_default)
                VALUES (
                    'DEFAULT',
                    :NEW.client_id,
                    :NEW.project_id,
                    'Y',
                    'Y'
                );
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL;
            END;
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
            SET t.is_default        = 'Y',
                t.updated_by        = 'STOP'        -- a hacky way how to stop recursion
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

