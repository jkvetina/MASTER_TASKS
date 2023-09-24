CREATE OR REPLACE TRIGGER tsk_boards__
FOR UPDATE OR INSERT OR DELETE ON tsk_boards
COMPOUND TRIGGER

    c_table_name CONSTANT VARCHAR2(128) := 'TSK_BOARDS';
    --
    v_client_id         tsk_boards.client_id%TYPE;
    v_project_id        tsk_boards.project_id%TYPE;
    v_board_id          tsk_boards.board_id%TYPE;



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
                v_board_id      := :NEW.board_id;
            END IF;
            --
        ELSE
            IF :OLD.is_default = 'Y' THEN
                v_client_id     := :OLD.client_id;
                v_project_id    := :OLD.project_id;
                v_board_id      := :OLD.board_id;
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
        -- make sure every project has exactly one default board
        IF v_board_id IS NOT NULL THEN
            UPDATE tsk_boards t
            SET t.is_default        = NULL
            WHERE t.client_id       = v_client_id
                AND t.project_id    = v_project_id
                AND t.is_default    = 'Y';
            --
            UPDATE tsk_boards t
            SET t.is_default        = 'Y'
            WHERE t.client_id       = v_client_id
                AND t.project_id    = v_project_id
                AND t.board_id      = v_board_id;
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

