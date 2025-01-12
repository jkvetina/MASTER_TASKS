prompt --application/shared_components/logic/application_processes/init_defaults
begin
--   Manifest
--     APPLICATION PROCESS: INIT_DEFAULTS
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
 p_id=>wwv_flow_imp.id(53704939397727401)
,p_process_sequence=>0
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_DEFAULTS'
,p_process_sql_clob=>'master.app.init_defaults();'
,p_process_clob_language=>'PLSQL'
,p_reference_id=>14906665904648711
,p_version_scn=>42188994146240
);
wwv_flow_imp.component_end;
end;
/
