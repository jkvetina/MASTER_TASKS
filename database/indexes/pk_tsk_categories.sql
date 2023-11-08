CREATE UNIQUE INDEX pk_tsk_categories
    ON tsk_categories (client_id, project_id, category_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

