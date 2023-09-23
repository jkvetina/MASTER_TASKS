prompt --application/shared_components/logic/application_processes/ajax_ping
begin
--   Manifest
--     APPLICATION PROCESS: AJAX_PING
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.2'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(35361836373726315)
,p_process_sequence=>0
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJAX_PING'
,p_process_sql_clob=>'app.ajax_ping();'
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
);
wwv_flow_imp.component_end;
end;
/
