CREATE OR REPLACE PACKAGE tsk_handlers AS

    PROCEDURE save_clients;



    PROCEDURE save_projects;



    PROCEDURE save_boards;



    PROCEDURE save_statuses;



    PROCEDURE save_swimlanes;



    PROCEDURE save_categories;



    PROCEDURE save_sequences;



    PROCEDURE reorder_statuses;



    PROCEDURE copy_statuses;



    PROCEDURE reorder_swimlanes;



    PROCEDURE copy_swimlanes;



    PROCEDURE reorder_categories;



    PROCEDURE copy_categories;

END;
/

