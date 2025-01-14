CREATE OR REPLACE PACKAGE tsk_handlers AS

    PROCEDURE init_project (
        in_client_id        tsk_cards.client_id%TYPE,
        in_project_id       tsk_cards.project_id%TYPE
    );



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

