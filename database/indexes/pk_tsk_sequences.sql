CREATE UNIQUE INDEX pk_tsk_sequences
    ON tsk_sequences (client_id, sequence_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

