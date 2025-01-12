ALTER SESSION SET CURRENT_SCHEMA = master;

--
-- PACKAGE
--
GRANT EXECUTE ON app TO apps;
GRANT EXECUTE ON app_auth TO apps;
GRANT EXECUTE ON app_nav TO apps;
GRANT EXECUTE ON core TO apps WITH GRANT OPTION;
GRANT EXECUTE ON core_custom TO apps WITH GRANT OPTION;
GRANT EXECUTE ON core_tapi TO apps WITH GRANT OPTION;

--
-- PROCEDURE
--
GRANT EXECUTE ON recompile TO apps WITH GRANT OPTION;

--
-- VIEW
--
GRANT DELETE ON app_contexts_vpd_v TO apps;
GRANT INSERT ON app_contexts_vpd_v TO apps;
GRANT SELECT ON app_contexts_vpd_v TO apps;
GRANT UPDATE ON app_contexts_vpd_v TO apps;
GRANT DELETE ON app_lovs_vpd_v TO apps;
GRANT INSERT ON app_lovs_vpd_v TO apps;
GRANT SELECT ON app_lovs_vpd_v TO apps;
GRANT UPDATE ON app_lovs_vpd_v TO apps;
GRANT SELECT ON app_navigation_vpd_v TO apps;
GRANT DELETE ON app_settings_vpd_v TO apps;
GRANT INSERT ON app_settings_vpd_v TO apps;
GRANT SELECT ON app_settings_vpd_v TO apps;
GRANT UPDATE ON app_settings_vpd_v TO apps;
GRANT DELETE ON app_users_vpd_v TO apps;
GRANT INSERT ON app_users_vpd_v TO apps;
GRANT SELECT ON app_users_vpd_v TO apps;
GRANT UPDATE ON app_users_vpd_v TO apps;
GRANT DELETE ON app_user_roles_vpd_v TO apps;
GRANT INSERT ON app_user_roles_vpd_v TO apps;
GRANT SELECT ON app_user_roles_vpd_v TO apps;
GRANT UPDATE ON app_user_roles_vpd_v TO apps;
GRANT DELETE ON app_user_vpd_v TO apps;
GRANT INSERT ON app_user_vpd_v TO apps;
GRANT SELECT ON app_user_vpd_v TO apps;
GRANT UPDATE ON app_user_vpd_v TO apps;

ALTER SESSION SET CURRENT_SCHEMA = APPS;

