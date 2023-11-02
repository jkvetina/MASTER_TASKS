CREATE OR REPLACE PACKAGE tsk_handlers AS

    PROCEDURE save_clients;



    PROCEDURE save_projects;



    PROCEDURE save_boards;



    PROCEDURE save_statuses;



    PROCEDURE save_swimlanes;



    PROCEDURE save_categories;



    PROCEDURE save_sequences;



    PROCEDURE copy_statuses;



    PROCEDURE copy_swimlanes;



    PROCEDURE copy_categories;



    PROCEDURE reorder_swimlanes;



    PROCEDURE reorder_statuses;



    PROCEDURE reorder_categories;



    PROCEDURE reorder_sequences;



    PROCEDURE reorder_boards;

END;
/

