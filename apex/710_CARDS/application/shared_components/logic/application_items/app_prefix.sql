prompt --application/shared_components/logic/application_items/app_prefix
begin
--   Manifest
--     APPLICATION ITEM: APP_PREFIX
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
 p_id=>wwv_flow_imp.id(39932917481197516)
,p_name=>'APP_PREFIX'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
,p_reference_id=>16460172305127574
,p_version_scn=>42101154114050
);
wwv_flow_imp.component_end;
end;
/
