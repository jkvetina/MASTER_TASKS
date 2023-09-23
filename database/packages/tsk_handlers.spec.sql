CREATE OR REPLACE PACKAGE tsk_handlers AS

    PROCEDURE save_clients;



    PROCEDURE save_projects;



    PROCEDURE create_default_swimlane (
        in_client_id        tsk_projects.client_id%TYPE,
        in_project_id       tsk_projects.project_id%TYPE
    );



    PROCEDURE save_statuses;



    PROCEDURE save_swimlanes;



    PROCEDURE save_categories;



    PROCEDURE reorder_statuses;



    PROCEDURE reorder_swimlanes;



    PROCEDURE reorder_categories;

END;
/

