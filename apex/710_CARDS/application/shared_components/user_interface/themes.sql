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
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(40419379248866487)
,p_theme_id=>800
,p_theme_name=>'Universal Theme [Q]'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_version_identifier=>'24.1'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>12839111496085052
,p_is_locked=>false
,p_default_page_template=>wwv_flow_imp.id(40178692949865817)
,p_default_dialog_template=>wwv_flow_imp.id(40170070310865798)
,p_error_template=>wwv_flow_imp.id(40160002875865779)
,p_printer_friendly_template=>wwv_flow_imp.id(40178692949865817)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_imp.id(40160002875865779)
,p_default_button_template=>wwv_flow_imp.id(40329918987866155)
,p_default_region_template=>wwv_flow_imp.id(40188776166865839)
,p_default_chart_template=>wwv_flow_imp.id(40255369489865979)
,p_default_form_template=>wwv_flow_imp.id(40255369489865979)
,p_default_reportr_template=>wwv_flow_imp.id(40255369489865979)
,p_default_tabform_template=>wwv_flow_imp.id(40255369489865979)
,p_default_wizard_template=>wwv_flow_imp.id(40255369489865979)
,p_default_menur_template=>wwv_flow_imp.id(40267705378866005)
,p_default_listr_template=>wwv_flow_imp.id(40255369489865979)
,p_default_irr_template=>wwv_flow_imp.id(40245523432865959)
,p_default_report_template=>wwv_flow_imp.id(40293783336866064)
,p_default_label_template=>wwv_flow_imp.id(40327496873866147)
,p_default_menu_template=>wwv_flow_imp.id(40331515369866159)
,p_default_calendar_template=>wwv_flow_imp.id(40331635817866160)
,p_default_list_template=>wwv_flow_imp.id(40310358120866104)
,p_default_nav_list_template=>wwv_flow_imp.id(40323147386866135)
,p_default_top_nav_list_temp=>wwv_flow_imp.id(40316797971866120)
,p_default_side_nav_list_temp=>wwv_flow_imp.id(40316797971866120)
,p_default_nav_list_position=>'TOP'
,p_default_dialogbtnr_template=>wwv_flow_imp.id(40191527463865844)
,p_default_dialogr_template=>wwv_flow_imp.id(40188776166865839)
,p_default_option_label=>wwv_flow_imp.id(40327496873866147)
,p_default_required_label=>wwv_flow_imp.id(40328770569866151)
,p_default_navbar_list_template=>wwv_flow_imp.id(40316797971866120)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(800),'#APEX_FILES#themes/theme_42/24.1/')
,p_files_version=>64
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APEX_FILES#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_FILES#js/theme42#MIN#.js?v=#APEX_VERSION#',
'',
'#WORKSPACE_FILES#master_app#MIN#.js?ver=#APP_VERSION#',
'#APP_FILES#app#MIN#.js?ver=#APP_VERSION#'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#THEME_FILES#css/Core#MIN#.css?v=#APEX_VERSION#',
'',
'#WORKSPACE_FILES#master_fonts#MIN#.css?ver=#APP_VERSION#',
'#WORKSPACE_FILES#master_app#MIN#.css?ver=#APP_VERSION#',
'#WORKSPACE_FILES#master_menu_top#MIN#.css?ver=#APP_VERSION#',
'#APP_FILES#app#MIN#.css?ver=#APP_VERSION#'))
);
wwv_flow_imp.component_end;
end;
/
