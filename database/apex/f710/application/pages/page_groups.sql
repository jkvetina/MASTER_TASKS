prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 710
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.2'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(23490192563159466)  --    MAIN - CARDS
,p_group_name=>'   MAIN - CARDS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(23490292620162217)  --   MAIN - BOARDS
,p_group_name=>'  MAIN - BOARDS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(78006013489194627)  --  MAIN - PROJECTS
,p_group_name=>' MAIN - PROJECTS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(34426432007203133)  -- __ INTERNAL
,p_group_name=>'__ INTERNAL'
);
wwv_flow_imp.component_end;
end;
/
