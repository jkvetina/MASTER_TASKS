ALTER SESSION SET CURRENT_SCHEMA = sys;

--
-- PACKAGE
--
GRANT EXECUTE           ON sys.dbms_application_info          TO apps;
GRANT EXECUTE           ON sys.dbms_scheduler                 TO apps;
GRANT EXECUTE           ON sys.dbms_session                   TO apps;
GRANT EXECUTE           ON sys.dbms_utility                   TO apps;

--
-- VIEW
--
GRANT SELECT            ON sys.v_$session                     TO apps;
GRANT SELECT            ON sys.v_$sql                         TO apps;
GRANT SELECT            ON sys.v_$sql_cursor                  TO apps;

ALTER SESSION SET CURRENT_SCHEMA = apps;

