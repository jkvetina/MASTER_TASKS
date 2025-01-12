prompt --application/shared_components/logic/application_items/context_page
begin
--   Manifest
--     APPLICATION ITEM: CONTEXT_PAGE
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
 p_id=>wwv_flow_imp.id(39939660394197531)
,p_name=>'CONTEXT_PAGE'
,p_scope=>'GLOBAL'
,p_protection_level=>'N'
,p_reference_id=>13991138632197038
,p_version_scn=>42101049033764
);
wwv_flow_imp.component_end;
end;
/
