prompt --application/shared_components/navigation/lists/navigation
begin
--   Manifest
--     LIST: NAVIGATION
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.2'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(33790933661125336)
,p_name=>'NAVIGATION'
,p_list_type=>'SQL_QUERY'
,p_list_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    t.lvl,',
'    t.label,',
'    t.target,',
'    t.is_current_list_entry,',
'    t.image,',
'    t.image_attribute,',
'    t.image_alt_attribute,',
'    t.attribute01,',
'    t.attribute02,',
'    t.attribute03,',
'    t.attribute04,',
'    t.attribute05,',
'    t.attribute06,',
'    t.attribute07,',
'    t.attribute08,',
'    t.attribute09,',
'    t.attribute10',
'FROM app_navigation_v t',
'ORDER BY t.order# NULLS FIRST;'))
,p_list_status=>'PUBLIC'
);
wwv_flow_imp.component_end;
end;
/
