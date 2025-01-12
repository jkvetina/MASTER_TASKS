prompt --application/shared_components/logic/application_items/user_first_name
begin
--   Manifest
--     APPLICATION ITEM: USER_FIRST_NAME
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(39937208722197526)
,p_name=>'USER_FIRST_NAME'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
,p_reference_id=>13992474600209377
,p_version_scn=>42101049126779
);
wwv_flow_imp.component_end;
end;
/
