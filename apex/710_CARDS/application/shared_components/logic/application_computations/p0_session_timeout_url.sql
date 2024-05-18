prompt --application/shared_components/logic/application_computations/p0_session_timeout_url
begin
--   Manifest
--     APPLICATION COMPUTATION: P0_SESSION_TIMEOUT_URL
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_flow_computation(
 p_id=>wwv_flow_imp.id(38790755662741856)
,p_computation_sequence=>10
,p_computation_item=>'P0_SESSION_TIMEOUT_URL'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'APEX_PAGE.GET_URL (',
'    p_application   => 800,',
'    p_page          => 9999,',
'    p_session       => 0,',
'    p_items         => ''P9999_ERROR'',',
'    p_values        => ''SESSION_TIMEOUT''',
')'))
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
