prompt --application/shared_components/logic/application_processes/ajax_favorite_switch
begin
--   Manifest
--     APPLICATION PROCESS: AJAX_FAVORITE_SWITCH
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(39941581183197539)
,p_process_sequence=>0
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJAX_FAVORITE_SWITCH'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.favorite_switch (',
'    in_app_id           => APEX_APPLICATION.G_X01,',
'    in_page_id          => APEX_APPLICATION.G_X02,',
'    in_element_id       => APEX_APPLICATION.G_X03,',
'    in_favorite_type    => APEX_APPLICATION.G_X04,',
'    in_favorite_id      => APEX_APPLICATION.G_X05',
');'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_reference_id=>20377427996780225
,p_version_scn=>42188921969473
);
wwv_flow_imp.component_end;
end;
/