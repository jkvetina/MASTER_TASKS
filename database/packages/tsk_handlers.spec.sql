CREATE OR REPLACE PACKAGE tsk_handlers AS

    PROCEDURE save_clients;



    PROCEDURE save_projects;



    PROCEDURE save_boards;



    PROCEDURE save_statuses;



    PROCEDURE save_milestones;



    PROCEDURE save_categories;



    PROCEDURE save_sequences;



    PROCEDURE copy_statuses;



    PROCEDURE copy_milestones;



    PROCEDURE copy_categories;



    PROCEDURE reorder_milestones;



    PROCEDURE reorder_statuses;



    PROCEDURE reorder_categories;



    PROCEDURE reorder_sequences;



    PROCEDURE reorder_boards;

END;
/

