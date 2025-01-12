prompt --application/shared_components/logic/application_items/format_time
begin
--   Manifest
--     APPLICATION ITEM: FORMAT_TIME
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
 p_id=>wwv_flow_imp.id(52934882432540119)
,p_name=>'FORMAT_TIME'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
,p_reference_id=>16634043174114947
,p_version_scn=>42101190491301
);
wwv_flow_imp.component_end;
end;
/
