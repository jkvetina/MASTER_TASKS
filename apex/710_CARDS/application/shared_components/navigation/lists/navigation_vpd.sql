prompt --application/shared_components/navigation/lists/navigation_vpd
begin
--   Manifest
--     LIST: NAVIGATION_VPD
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(40056462880331034)  -- LIST: NAVIGATION_VPD
,p_name=>'NAVIGATION_VPD'
,p_list_type=>'SQL_QUERY'
,p_list_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    t.lvl,',
'    --',
'    NULL AS label,',
'    NULL AS target,',
'    NULL AS is_current_list_entry,',
'    NULL AS image,',
'    NULL AS image_attribute,',
'    NULL AS image_alt_attribute,',
'    --',
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
'    --',
'FROM master.app_navigation_VPD_v t',
'ORDER BY',
'    t.order# NULLS FIRST;'))
,p_list_status=>'PUBLIC'
,p_reference_id=>40056882291338182
,p_version_scn=>42190255210303
);
wwv_flow_imp.component_end;
end;
/