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
,p_default_owner=>'APPS'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(42668205046306704)  -- PAGE GROUP: 1) Cards
,p_group_name=>'1) Cards'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(45948121457602853)  -- PAGE GROUP: 2) Clients and Projects Setup
,p_group_name=>'2) Clients and Projects Setup'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(46105398881273954)  -- PAGE GROUP: 5) Commits
,p_group_name=>'5) Commits'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(53604444490350371)  -- PAGE GROUP: __ INTERNAL
,p_group_name=>'__ INTERNAL'
);
wwv_flow_imp.component_end;
end;
/
