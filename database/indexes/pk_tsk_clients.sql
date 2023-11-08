CREATE UNIQUE INDEX pk_tsk_clients
    ON tsk_clients (client_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

