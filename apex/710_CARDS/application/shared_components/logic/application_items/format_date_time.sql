prompt --application/shared_components/logic/application_items/format_date_time
begin
--   Manifest
--     APPLICATION ITEM: FORMAT_DATE_TIME
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'MASTER'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(52935685290545152)
,p_name=>'FORMAT_DATE_TIME'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
,p_reference_id=>16632711026102127
,p_version_scn=>42101190415345
);
wwv_flow_imp.component_end;
end;
/
