prompt --application/shared_components/logic/application_items/format_date
begin
--   Manifest
--     APPLICATION ITEM: FORMAT_DATE
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
 p_id=>wwv_flow_imp.id(52935255067542347)
,p_name=>'FORMAT_DATE'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
,p_reference_id=>16632585076100009
,p_version_scn=>42101190392902
);
wwv_flow_imp.component_end;
end;
/
