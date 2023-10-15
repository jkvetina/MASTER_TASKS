prompt --application/create_application
begin
--   Manifest
--     FLOW: 710
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.2'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_imp_workspace.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'APPS')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'Card Crunchers')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'CARDS')
,p_application_group=>wwv_flow_imp.id(14521045818542929)
,p_application_group_name=>'LAUNCHPAD'
,p_application_group_comment=>'Apps visible in Launchpad'
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'9CBCC171912554FE4A8996BCA5DC653BEC59C661B634BF18F954B71B4DA3D6FD'
,p_bookmark_checksum_function=>'SH512'
,p_max_session_length_sec=>86400
,p_on_max_session_timeout_url=>'#LOGOUT_URL#'
,p_max_session_idle_sec=>14400
,p_on_max_idle_timeout_url=>'#LOGOUT_URL#'
,p_session_timeout_warning_sec=>0
,p_compatibility_mode=>'21.2'
,p_session_state_commits=>'IMMEDIATE'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_date_format=>'&FORMAT_DATE.'
,p_date_time_format=>'&FORMAT_DATE_TIME.'
,p_timestamp_format=>'DS'
,p_timestamp_tz_format=>'DS'
,p_direction_right_to_left=>'N'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_documentation_banner=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Created by Jan Kvetina, 9/2023',
'www.jankvetina.cz'))
,p_authentication_id=>wwv_flow_imp.id(70311275564704853)
,p_populate_roles=>'C'
,p_application_tab_set=>1
,p_logo_type=>'T'
,p_logo_text=>'&APP_NAME.'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'2023-10-15'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable at this time.'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_deep_linking=>'Y'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'N'
,p_auto_time_zone=>'N'
,p_error_handling_function=>'core.handle_apex_error'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'Card Crunchers'
,p_substitution_string_02=>'APP_DESC'
,p_substitution_value_02=>'Simple tasks/cards management on kanban style board with checklists/acceptance criteria and more...'
,p_substitution_string_03=>'APP_PREFIX'
,p_substitution_value_03=>'TSK_'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220101000000'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>616
,p_print_server_type=>'NATIVE'
,p_is_pwa=>'Y'
,p_pwa_is_installable=>'N'
);
wwv_flow_imp.component_end;
end;
/
