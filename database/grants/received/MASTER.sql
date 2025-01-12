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
-- TABLE
--
GRANT ALTER ON app_contexts TO apps;
GRANT DEBUG ON app_contexts TO apps;
GRANT DELETE ON app_contexts TO apps;
GRANT FLASHBACK ON app_contexts TO apps;
GRANT INDEX ON app_contexts TO apps;
GRANT INSERT ON app_contexts TO apps;
GRANT ON COMMIT REFRESH ON app_contexts TO apps;
GRANT QUERY REWRITE ON app_contexts TO apps;
GRANT READ ON app_contexts TO apps;
GRANT REFERENCES ON app_contexts TO apps;
GRANT SELECT ON app_contexts TO apps;
GRANT UPDATE ON app_contexts TO apps;
GRANT ALTER ON app_lovs TO apps;
GRANT DEBUG ON app_lovs TO apps;
GRANT DELETE ON app_lovs TO apps;
GRANT FLASHBACK ON app_lovs TO apps;
GRANT INDEX ON app_lovs TO apps;
GRANT INSERT ON app_lovs TO apps;
GRANT ON COMMIT REFRESH ON app_lovs TO apps;
GRANT QUERY REWRITE ON app_lovs TO apps;
GRANT READ ON app_lovs TO apps;
GRANT REFERENCES ON app_lovs TO apps;
GRANT SELECT ON app_lovs TO apps;
GRANT UPDATE ON app_lovs TO apps;
GRANT ALTER ON app_settings TO apps;
GRANT DEBUG ON app_settings TO apps;
GRANT DELETE ON app_settings TO apps;
GRANT FLASHBACK ON app_settings TO apps;
GRANT INDEX ON app_settings TO apps;
GRANT INSERT ON app_settings TO apps;
GRANT ON COMMIT REFRESH ON app_settings TO apps;
GRANT QUERY REWRITE ON app_settings TO apps;
GRANT READ ON app_settings TO apps;
GRANT REFERENCES ON app_settings TO apps;
GRANT SELECT ON app_settings TO apps;
GRANT UPDATE ON app_settings TO apps;

--
-- VIEW
--
GRANT SELECT ON app_init_defaults_v TO apps;
GRANT SELECT ON app_launchpad_v TO apps;
GRANT SELECT ON app_lov_apex_apps_v TO apps;
GRANT SELECT ON app_lov_apex_app_groups_v TO apps;
GRANT SELECT ON app_lov_apex_owners_v TO apps;
GRANT SELECT ON app_lov_apex_pages_v TO apps;
GRANT SELECT ON app_lov_applications_v TO apps;
GRANT SELECT ON app_lov_roles_v TO apps;
GRANT SELECT ON app_lov_role_groups_v TO apps;
GRANT SELECT ON app_lov_users_all_v TO apps;
GRANT SELECT ON app_lov_users_v TO apps;
GRANT SELECT ON app_navigation_badges_v TO apps;
GRANT SELECT ON app_navigation_grid_v TO apps;
GRANT SELECT ON app_navigation_map_mv_src TO apps;
GRANT SELECT ON app_navigation_map_v TO apps;
GRANT SELECT ON app_navigation_v TO apps;
GRANT SELECT ON app_users_grid_v TO apps;
GRANT SELECT ON app_user_roles_v TO apps;

ALTER SESSION SET CURRENT_SCHEMA = APPS;

