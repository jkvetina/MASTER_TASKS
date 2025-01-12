prompt --application/shared_components/logic/application_processes/after_auth
begin
--   Manifest
--     APPLICATION PROCESS: AFTER_AUTH
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
 p_id=>wwv_flow_imp.id(39942704319197545)
,p_process_sequence=>-10
,p_process_point=>'AFTER_LOGIN'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AFTER_AUTH'
,p_process_sql_clob=>'master.app_auth.after_auth();'
,p_process_clob_language=>'PLSQL'
,p_reference_id=>14906883819651706
,p_version_scn=>42101121784681
);
wwv_flow_imp.component_end;
end;
/
