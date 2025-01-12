prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 710
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'MASTER'
);
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(53284449249301150)
,p_theme_id=>800
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_version_identifier=>'23.2'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>63467056572439181
,p_is_locked=>false
,p_default_page_template=>wwv_flow_imp.id(50563362927791187)
,p_default_dialog_template=>wwv_flow_imp.id(53037134040300958)
,p_error_template=>wwv_flow_imp.id(53027090493300952)
,p_printer_friendly_template=>wwv_flow_imp.id(53042336706300960)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_imp.id(53027090493300952)
,p_default_button_template=>wwv_flow_imp.id(53199485680301065)
,p_default_region_template=>wwv_flow_imp.id(53059267411300973)
,p_default_chart_template=>wwv_flow_imp.id(53125814628301010)
,p_default_form_template=>wwv_flow_imp.id(53125814628301010)
,p_default_reportr_template=>wwv_flow_imp.id(53125814628301010)
,p_default_tabform_template=>wwv_flow_imp.id(53125814628301010)
,p_default_wizard_template=>wwv_flow_imp.id(53125814628301010)
,p_default_menur_template=>wwv_flow_imp.id(53138278154301017)
,p_default_listr_template=>wwv_flow_imp.id(53125814628301010)
,p_default_irr_template=>wwv_flow_imp.id(53116064012301005)
,p_default_report_template=>wwv_flow_imp.id(53164076563301035)
,p_default_label_template=>wwv_flow_imp.id(53196954686301058)
,p_default_menu_template=>wwv_flow_imp.id(53201006059301066)
,p_default_calendar_template=>wwv_flow_imp.id(53201107252301067)
,p_default_list_template=>wwv_flow_imp.id(53180482350301046)
,p_default_nav_list_template=>wwv_flow_imp.id(53192624924301053)
,p_default_top_nav_list_temp=>wwv_flow_imp.id(50862278708791397)
,p_default_side_nav_list_temp=>wwv_flow_imp.id(50862278708791397)
,p_default_nav_list_position=>'TOP'
,p_default_dialogbtnr_template=>wwv_flow_imp.id(53062062552300975)
,p_default_dialogr_template=>wwv_flow_imp.id(53059267411300973)
,p_default_option_label=>wwv_flow_imp.id(53196954686301058)
,p_default_required_label=>wwv_flow_imp.id(53198196723301060)
,p_default_navbar_list_template=>wwv_flow_imp.id(50862278708791397)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(800),'#APEX_FILES#themes/theme_42/23.2/')
,p_files_version=>64
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APEX_FILES#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_FILES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_FILES#css/Core#MIN#.css?v=#APEX_VERSION#'
);
wwv_flow_imp.component_end;
end;
/
