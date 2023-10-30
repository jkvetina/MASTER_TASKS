prompt --application/pages/page_00360
begin
--   Manifest
--     PAGE: 00360
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.5'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_page.create_page(
 p_id=>360
,p_name=>'Owners'
,p_alias=>'OWNERS'
,p_step_title=>'Owners'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(78006013489194627)  -- 3) PROJECTS
,p_page_css_classes=>'MULTICOLUMN'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(70314822393792529)  -- MASTER - IS_USER
,p_protection_level=>'C'
,p_page_component_map=>'11'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220101000000'
);
wwv_flow_imp.component_end;
end;
/
