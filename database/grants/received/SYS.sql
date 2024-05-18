ALTER SESSION SET CURRENT_SCHEMA = sys;

--
-- PACKAGE
--
GRANT EXECUTE ON dbms_application_info TO apps;
GRANT EXECUTE ON dbms_scheduler TO apps;
GRANT EXECUTE ON dbms_session TO apps;
GRANT EXECUTE ON dbms_utility TO apps;

--
-- VIEW
--
GRANT SELECT ON v_$session TO apps;
GRANT SELECT ON v_$sql TO apps;
GRANT SELECT ON v_$sql_cursor TO apps;

ALTER SESSION SET CURRENT_SCHEMA = APPS;

