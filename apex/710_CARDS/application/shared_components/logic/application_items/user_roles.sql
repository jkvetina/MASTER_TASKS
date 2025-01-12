prompt --application/shared_components/logic/application_items/user_roles
begin
--   Manifest
--     APPLICATION ITEM: USER_ROLES
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
 p_id=>wwv_flow_imp.id(39936046577197524)
,p_name=>'USER_ROLES'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
,p_reference_id=>13992888604212407
,p_version_scn=>42101049148292
);
wwv_flow_imp.component_end;
end;
/
