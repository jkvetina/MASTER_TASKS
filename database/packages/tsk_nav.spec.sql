CREATE OR REPLACE PACKAGE tsk_nav AS

    FUNCTION get_home
    RETURN VARCHAR2;



    FUNCTION get_clients
    RETURN VARCHAR2;



    FUNCTION get_projects
    RETURN VARCHAR2;



    FUNCTION get_boards
    RETURN VARCHAR2;



    FUNCTION get_commits
    RETURN VARCHAR2;

END;
/

