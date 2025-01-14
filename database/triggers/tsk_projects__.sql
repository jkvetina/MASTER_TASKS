CREATE OR REPLACE TRIGGER tsk_projects__
FOR UPDATE OR INSERT OR DELETE ON tsk_projects
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_PROJECTS';
    --
    v_client_id         tsk_projects.client_id%TYPE;
    v_project_id        tsk_projects.project_id%TYPE;
    --
    v_new_project       tsk_projects.client_id%TYPE;



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
        END IF;
        --
        IF INSERTING THEN
            v_new_project := :NEW.client_id;
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

        -- create default project structure
        IF v_new_project IS NOT NULL THEN
            -- find client projects without boards
            FOR c IN (
                SELECT DISTINCT
                    p.project_id
                FROM tsk_projects p
                LEFT JOIN tsk_boards b
                    ON b.client_id      = p.client_id
                    AND b.project_id    = p.project_id
                WHERE p.client_id       = v_new_project
                    AND b.board_id      IS NULL
            ) LOOP
                tsk_handlers.init_project (
                    in_client_id    => v_new_project,
                    in_project_id   => c.project_id
                );
            END LOOP;
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

