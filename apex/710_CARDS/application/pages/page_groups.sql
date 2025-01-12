prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 710
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'MASTER'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(42668205046306704)  -- PAGE GROUP: 1) CARDS
,p_group_name=>'1) CARDS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(45948121457602853)  -- PAGE GROUP: 2) CLIENTS
,p_group_name=>'2) CLIENTS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(97184025972341865)  -- PAGE GROUP: 3) PROJECTS
,p_group_name=>'3) PROJECTS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(42668305103309455)  -- PAGE GROUP: 4) BOARDS
,p_group_name=>'4) BOARDS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(46105398881273954)  -- PAGE GROUP: 5) COMMITS
,p_group_name=>'5) COMMITS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(53604444490350371)  -- PAGE GROUP: __ INTERNAL
,p_group_name=>'__ INTERNAL'
);
wwv_flow_imp.component_end;
end;
/
