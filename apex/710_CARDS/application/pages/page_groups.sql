prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 710
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(23490192563159466)  -- PAGE GROUP: 1) CARDS
,p_group_name=>'1) CARDS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(26770108974455615)  -- PAGE GROUP: 2) CLIENTS
,p_group_name=>'2) CLIENTS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(78006013489194627)  -- PAGE GROUP: 3) PROJECTS
,p_group_name=>'3) PROJECTS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(23490292620162217)  -- PAGE GROUP: 4) BOARDS
,p_group_name=>'4) BOARDS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(26927386398126716)  -- PAGE GROUP: 5) COMMITS
,p_group_name=>'5) COMMITS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(34426432007203133)  -- PAGE GROUP: __ INTERNAL
,p_group_name=>'__ INTERNAL'
);
wwv_flow_imp.component_end;
end;
/
