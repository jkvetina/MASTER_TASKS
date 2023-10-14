CREATE OR REPLACE PACKAGE tsk_p110 AS

    c_coll_card_filter      CONSTANT VARCHAR2(30) := 'TSK_P110_CARD_FILTERS';



    PROCEDURE process_bulk_init;



    PROCEDURE process_bulk_filters;



    PROCEDURE process_bulk_request;

END;
/

