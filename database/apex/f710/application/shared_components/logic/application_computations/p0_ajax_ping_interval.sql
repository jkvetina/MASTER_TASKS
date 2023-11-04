prompt --application/shared_components/logic/application_computations/p0_ajax_ping_interval
begin
--   Manifest
--     APPLICATION COMPUTATION: P0_AJAX_PING_INTERVAL
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.5'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_flow_computation(
 p_id=>wwv_flow_imp.id(38790501784738931)
,p_computation_sequence=>10
,p_computation_item=>'P0_AJAX_PING_INTERVAL'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'CASE WHEN core.get_page_is_modal(:APP_ID, :APP_PAGE_ID) = ''Y''',
'    THEN 0',
'    ELSE 6 END'))
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
);
wwv_flow_imp.component_end;
end;
/
