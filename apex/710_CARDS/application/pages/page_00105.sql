prompt --application/pages/page_00105
begin
--   Manifest
--     PAGE: 00105
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_page.create_page(
 p_id=>105
,p_name=>'Card Detail'
,p_alias=>'CARD'
,p_page_mode=>'MODAL'
,p_step_title=>'Card Detail'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(42668205046306704)  -- PAGE GROUP: 1) Cards
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'const submit_checklist = function (button_id) {',
'    renumber_grid_rows(''CHECKLIST'', ''NEW_ORDER'');',
'    apex.submit(button_id);',
'};',
'',
'',
'',
'const delete_comment = function (card_id, comment_id) {',
'    apex.server.process(''AJAX_DELETE_COMMENT'',',
'        {',
'            x01: card_id,',
'            x02: comment_id',
'        },',
'        {',
'            dataType: ''text'',',
'            success: function(pData) {',
'                console.log(''RESULT'', pData);',
'                if (pData.indexOf(''sqlerrm'') >= 0) {',
'                    apex.message.showErrors([{',
'                        type        : ''error'',',
'                        location    : [''page'', ''inline''],',
'                        pageItem    : '''',',
'                        message     : pData.split(''sqlerrm:'')[1],',
'                        unsafe      : false',
'                    }]);',
'                }',
'                else {',
'                    apex.message.showPageSuccess(pData);',
'                }',
'                //',
'                apex.region(''COMMENTS'').refresh();',
'            }',
'        }',
'    );',
'};',
'',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// CATCH ENTER KEY PRESS',
'const region_id = ''CHECKLIST'';',
'$(''#'' + region_id + '' .a-GV'').on(''keydown'', ''input'', function(event) {',
'    if (event.which === 13) {',
'        // add new line below current line',
'        var $widget = apex.region(region_id).widget();',
'        $widget.interactiveGrid(''getActions'').invoke(''selection-add-row'');',
'        event.stopPropagation();',
'    }',
'});',
'',
'// MAKE THE GRID EDITABLE (WITH A DELAY)',
'$(function() {',
'    var static_id = ''CHECKLIST'';',
'    (function loop(i) {',
'        setTimeout(function() {',
'            try {',
'                var region  = apex.region(static_id);',
'                var grid    = region.widget();',
'                var model   = grid.interactiveGrid(''getViews'', ''grid'').model;',
'                var current = grid.interactiveGrid(''getViews'').grid.getSelectedRecords()[0];',
'                //',
'                region.call(''getActions'').set(''edit'', true);',
'                if (current !== undefined) {',
'                    return;',
'                }',
'            }',
'            catch(err) {',
'            }',
'            if (--i) loop(i);',
'        }, 100)',
'    })(20);',
'});',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* SWAP CHECKBOX AND ITEM */',
'table .a-GV-row,',
'table .a-GV-row .a-GV-cell {',
'    transform: scaleX(-1);',
'}',
'',
'/* HIDE DESC LABEL */',
'#P105_CARD_DESC_CONTAINER .t-Form-labelContainer {',
'    display: none;',
'}',
'#P105_CARD_DESC_CONTAINER .t-Form-itemWrapper {',
'    margin: 0 !important;',
'}',
'',
'/* HIDE UPLOADER LABEL */',
'#UPLOADER .t-Form-labelContainer,',
'#UPLOADER .apex-item-filedrop-heading,',
'.apex-item-filedrop-icon {',
'    display: none;',
'}',
'#UPLOADER div#P105_ATTACHED_FILES_GROUP {',
'    margin: 0.5rem 0 1rem;',
'}',
'#UPLOADER .apex-item-filedrop-action.a-Button.a-Button--hot {',
'    margin-top: 1rem;',
'}',
'',
'/* HIDE DISPLAY ONLY ITEM BORDERS */',
'.t-Form-itemWrapper .display_only.apex-item-display-only {',
'    border: 0;',
'    color: #555;',
'}',
'',
''))
,p_step_template=>wwv_flow_imp.id(40170070310865798)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(39926727961197497)  -- AUTHORIZATION: IS_USER
,p_dialog_width=>'85%'
,p_protection_level=>'C'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is Card detail, everything related to the card - descriptio, attachements, checklist, comments, commits...',
'',
'The main focus is on the checklist, which also serve the purpose of acceptance criteria. Instead of putting everything into the task description, you should create a list of things to do/check. If the description is needed, feel free to use it. Same '
||'for the files and comments.',
'',
'You can assign category, owner and deadline to each card.',
'',
'Every tab contains the badge if there is a content there requiring your attention.',
'',
'Under the [...] button there are hidden some less used actions. Arrows will save the changes and move you to the prev/next card in the same order as you saw them on the Board.'))
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(35710156580708544)
,p_plug_name=>'BUTTONS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44242895436877266)
,p_plug_name=>'LEFT'
,p_region_name=>'TABS_LEFT'
,p_region_css_classes=>'TABS'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_imp.id(40265132356865999)
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44243294609877270)
,p_plug_name=>'Attachements &P105_BADGE_FILES.'
,p_region_name=>'TAB_ATTACHEMENTS'
,p_parent_plug_id=>wwv_flow_imp.id(44242895436877266)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(58942979295473085)
,p_name=>'Files [REPORT]'
,p_region_name=>'ATTACHMENTS'
,p_parent_plug_id=>wwv_flow_imp.id(44243294609877270)
,p_template=>wwv_flow_imp.id(40188776166865839)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'TSK_P105_FILES_V'
,p_query_order_by_type=>'STATIC'
,p_query_order_by=>'ORDER#'
,p_include_rowid_column=>false
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1',
'FROM tsk_p105_files_v',
'WHERE ROWNUM = 1'))
,p_display_condition_type=>'EXISTS'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P105_CARD_ID'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(40284996843866043)
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(58943075671473086)
,p_query_column_id=>1
,p_column_alias=>'CARD_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Card Id'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(58943132731473087)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>20
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(58943258894473088)
,p_query_column_id=>3
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>30
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_column_link=>'javascript: { $.event.trigger(''DELETE_FILE'', {file_id:#COMMENT_ID#}); }'
,p_column_linktext=>'#ACTIONS#'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59201176481962139)
,p_query_column_id=>4
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>40
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59201279683962140)
,p_query_column_id=>5
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>50
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59201341856962141)
,p_query_column_id=>6
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>60
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59201494477962142)
,p_query_column_id=>7
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>70
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59201587896962143)
,p_query_column_id=>8
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>80
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59201702944962144)
,p_query_column_id=>9
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>90
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59201737380962145)
,p_query_column_id=>10
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>100
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59201900072962146)
,p_query_column_id=>11
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>110
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59202005512962147)
,p_query_column_id=>12
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>120
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59202032633962148)
,p_query_column_id=>13
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>130
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(59202204238962149)
,p_query_column_id=>14
,p_column_alias=>'ORDER#'
,p_column_display_sequence=>140
,p_column_heading=>'Order#'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(109797893066546685)
,p_plug_name=>'UPLOADER'
,p_region_name=>'UPLOADER'
,p_parent_plug_id=>wwv_flow_imp.id(44243294609877270)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44244095566877278)
,p_plug_name=>'Info'
,p_region_name=>'TAB_INFO'
,p_parent_plug_id=>wwv_flow_imp.id(44242895436877266)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(127494684967555269)
,p_plug_name=>'[FORM]'
,p_parent_plug_id=>wwv_flow_imp.id(44244095566877278)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'TABLE'
,p_query_table=>'TSK_CARDS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44657509221008161)
,p_plug_name=>'Description &P105_BADGE_DESC.'
,p_region_name=>'TAB_DESCRIPTION'
,p_parent_plug_id=>wwv_flow_imp.id(44242895436877266)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44657546241008162)
,p_plug_name=>'DETAILS'
,p_parent_plug_id=>wwv_flow_imp.id(44657509221008161)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47609064264111477)
,p_plug_name=>'Code Review &P105_BADGE_REVIEW.'
,p_parent_plug_id=>wwv_flow_imp.id(44242895436877266)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44657629749008163)
,p_plug_name=>'RIGHT'
,p_region_name=>'TABS_RIGHT'
,p_region_css_classes=>'TABS'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_imp.id(40265132356865999)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44242711670877264)
,p_plug_name=>'Checklist &P105_BADGE_CHECKLIST.'
,p_region_name=>'TAB_CHECKLIST'
,p_parent_plug_id=>wwv_flow_imp.id(44657629749008163)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(110541566711018499)
,p_plug_name=>'Checklist [GRID]'
,p_region_name=>'CHECKLIST'
,p_parent_plug_id=>wwv_flow_imp.id(44242711670877264)
,p_region_css_classes=>'ORIGINAL'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40245523432865959)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'TABLE'
,p_query_table=>'TSK_P105_CHECKLIST_V'
,p_query_order_by_type=>'STATIC'
,p_query_order_by=>'OLD_ORDER'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P105_CARD_ID'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Checklist [GRID]'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(46949730239460856)
,p_name=>'CSS_CLASS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CSS_CLASS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>100
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(58194452563082664)
,p_name=>'OLD_ORDER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'OLD_ORDER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>80
,p_attribute_01=>'N'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'-1'
,p_duplicate_value=>false
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(58194573988082665)
,p_name=>'NEW_ORDER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NEW_ORDER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>90
,p_attribute_01=>'N'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'-1'
,p_duplicate_value=>false
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(58195752828082677)
,p_name=>'CHECKLIST_LEVEL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CHECKLIST_LEVEL'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>70
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(110541822534018501)
,p_name=>'CHECKLIST_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CHECKLIST_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>40
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(110541863234018502)
,p_name=>'CHECKLIST_ITEM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CHECKLIST_ITEM'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Checklist Item'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_value_css_classes=>'CHECKLIST_ITEM'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>256
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(config) {',
'  config.defaultGridColumnOptions = {',
'    cellCssClassesColumn: ''CSS_CLASS''',
'  };',
'  return config;',
'}'))
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(110542020096018503)
,p_name=>'CHECKLIST_DONE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CHECKLIST_DONE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SINGLE_CHECKBOX'
,p_heading=>'Checklist Done'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'CENTER'
,p_value_css_classes=>'CHECKLIST_DONE'
,p_attribute_01=>'N'
,p_attribute_02=>'Y'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(110542090291018504)
,p_name=>'CARD_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CARD_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>30
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(110542349865018507)
,p_name=>'APEX$ROW_ACTION'
,p_source_type=>'NONE'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>20
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(110542460645018508)
,p_name=>'APEX$ROW_SELECTOR'
,p_source_type=>'NONE'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(110541682110018500)
,p_internal_uid=>91363669626871262
,p_is_editable=>true
,p_edit_operations=>'i:u'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>false
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_toolbar_buttons=>'ACTIONS_MENU:SAVE'
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>false
,p_enable_download=>false
,p_download_formats=>null
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(110581236023334783)
,p_interactive_grid_id=>wwv_flow_imp.id(110541682110018500)
,p_static_id=>'463001'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(110581418703334784)
,p_report_id=>wwv_flow_imp.id(110581236023334783)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(47002417701078958)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(46949730239460856)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(58613699136077596)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(58194452563082664)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(58614476891077599)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(58194573988082665)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(58637215385381691)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(58195752828082677)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(64281330627710680)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(110542460645018508)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(110581898895334791)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(110541822534018501)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(110582844530334794)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(110541863234018502)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(110583674268334797)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(110542020096018503)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>50
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(110584559182334800)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(110542090291018504)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(110587270818334809)
,p_view_id=>wwv_flow_imp.id(110581418703334784)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(110542349865018507)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44242736402877265)
,p_plug_name=>'Comments &P105_BADGE_COMMENTS.'
,p_region_name=>'TAB_COMMENTS'
,p_parent_plug_id=>wwv_flow_imp.id(44657629749008163)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(108451051217625384)
,p_name=>'Comments [REPORT]'
,p_region_name=>'COMMENTS'
,p_parent_plug_id=>wwv_flow_imp.id(44242736402877265)
,p_template=>wwv_flow_imp.id(40188776166865839)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'TSK_P105_COMMENTS_V'
,p_query_order_by_type=>'STATIC'
,p_query_order_by=>'ORDER#'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P105_CARD_ID'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(40284996843866043)
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44659327056008180)
,p_query_column_id=>1
,p_column_alias=>'CARD_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Card Id'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44409486734991763)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>20
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44409857047991764)
,p_query_column_id=>3
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>30
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_column_link=>'javascript: { $.event.trigger(''DELETE_COMMENT'', {card_id:#CARD_ID#, comment_id:#COMMENT_ID#}); }'
,p_column_linktext=>'#ACTIONS#'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44410247719991764)
,p_query_column_id=>4
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>40
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44410690933991764)
,p_query_column_id=>5
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>50
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44411030485991765)
,p_query_column_id=>6
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>60
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44411428320991765)
,p_query_column_id=>7
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>70
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44411851097991765)
,p_query_column_id=>8
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>80
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44412267522991765)
,p_query_column_id=>9
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>90
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44412640478991766)
,p_query_column_id=>10
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>100
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44413051311991766)
,p_query_column_id=>11
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>110
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44413457087991766)
,p_query_column_id=>12
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>120
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(44413898222991767)
,p_query_column_id=>13
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>130
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(56903639634100359)
,p_query_column_id=>14
,p_column_alias=>'ORDER#'
,p_column_display_sequence=>140
,p_column_heading=>'Order#'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47449644132141587)
,p_plug_name=>'Tags &P105_BADGE_TAGS.'
,p_region_name=>'TAB_TAGS'
,p_parent_plug_id=>wwv_flow_imp.id(44657629749008163)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(108375306679288722)
,p_plug_name=>'Commits &P105_BADGE_COMMITS.'
,p_region_name=>'TAB_COMMITS'
,p_parent_plug_id=>wwv_flow_imp.id(44657629749008163)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(109696390040716308)
,p_plug_name=>'Commits [LIST]'
,p_parent_plug_id=>wwv_flow_imp.id(108375306679288722)
,p_region_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(40195849749865853)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'TABLE'
,p_query_table=>'TSK_P105_COMMITS_V'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_JQM_LIST_VIEW'
,p_plug_query_num_rows=>15
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'link_target', 'javascript: { window.open(''&COMMIT_URL.'', ''_blank''); }',
  'supplemental_info_column', 'CREATED',
  'text_column', 'COMMIT_MESSAGE')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47608198560111468)
,p_plug_name=>'MORE_ACTIONS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40188776166865839)
,p_plug_display_sequence=>40
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN ''<div class="ACTION_MENU" data-id="MORE_ACTIONS">',
'<div class="WRAPPER"><div class="CONTENT">',
'    <ul role="menu">',
'        <li><a tabindex="-1" href="javascript:{ apex.submit({request:''''MOVE_TO_TOP_AND_CLOSE''''}); }"><span class="fa fa-page-top"></span> &nbsp; Move to the Top</a></li>',
'        <li><a tabindex="-1" href="javascript:{ apex.page.confirm(''''Do you really want to delete the card?'''', {request:''''DELETE_CARD_AND_CLOSE''''}); }"><span class="fa fa-trash-o"></span> &nbsp; Delete Card</a></li>',
'        <li><a tabindex="-1" href="javascript:{ apex.submit({request:''''DUPLICATE_CARD''''}); }"><span class="fa fa-copy"></span> &nbsp; Duplicate</a></li>',
'        <li><a tabindex="-1" href="javascript:{ apex.page.confirm(''''Do you want to move unchecked items to the new task?'''', {request:''''SPLIT_CARD''''}); }"><span class="fa fa-accessor-more"></span> &nbsp; Split Card by Checklist</a></li>',
'        <li><a tabindex="-1" href="javascript:{ apex.navigation.redirect(apex.item(''''P105_MERGE_URL'''').getValue()); }"><span class="fa fa-accessor-more fa-flip-horizontal"></span> &nbsp; Merge into Card</a></li>',
'        <li><a tabindex="-1" href="javascript:{ copy_to_clipboard(apex.item(''''P105_CARD_LINK'''').getValue());',
'show_success(''''Link copied to the clipboard''''); }"><span class="fa fa-share"></span> &nbsp; Copy as Link</a></li>',
'    </ul>',
'</div></div>',
'</div>'';'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P105_CARD_ID'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(127494529654555268)
,p_plug_name=>'&P105_HEADER.'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(40222089463865910)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44434057267991801)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(35710156580708544)
,p_button_name=>'CREATE_ANOTHER'
,p_button_static_id=>'CREATE_ANOTHER'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(40330034306866155)
,p_button_image_alt=>'and Another'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P105_CARD_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_button_css_classes=>'u-pullRight'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44434430741991801)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(35710156580708544)
,p_button_name=>'CREATE_CARD_AND_CLOSE'
,p_button_static_id=>'CREATE_CARD_AND_CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(40330034306866155)
,p_button_image_alt=>'and Close'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P105_CARD_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_button_css_classes=>'u-pullRight'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57584109329687346)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(35710156580708544)
,p_button_name=>'CREATE_CARD'
,p_button_static_id=>'CREATE_CARD'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(40330034306866155)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create Card'
,p_button_position=>'NEXT'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P105_CARD_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_button_css_classes=>'u-pullRight'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44434883474991801)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(35710156580708544)
,p_button_name=>'UPDATE_CARD_AND_CLOSE'
,p_button_static_id=>'UPDATE_CARD_AND_CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(40330034306866155)
,p_button_image_alt=>'and Close'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P105_CARD_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_button_css_classes=>'u-pullRight'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(46018001553168176)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(35710156580708544)
,p_button_name=>'UPDATE_AND_REFRESH'
,p_button_static_id=>'UPDATE_AND_REFRESH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(40330034306866155)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save Changes'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P105_CARD_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_button_css_classes=>'u-pullRight'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44438472867991804)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_button_name=>'GOTO_PREV_CARD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(40329256648866153)
,p_button_image_alt=>'Save changes and go to previous card'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_condition=>'P105_CARD_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-arrow-left'
,p_button_cattributes=>'&P105_DISABLE_PREV.'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44438034661991804)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_button_name=>'GOTO_NEXT_CARD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(40329256648866153)
,p_button_image_alt=>'Save changes and go to next card'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_condition=>'P105_CARD_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-arrow-right'
,p_button_cattributes=>'&P105_DISABLE_NEXT.'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(46600441715405880)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_button_name=>'MORE_ACTIONS'
,p_button_static_id=>'MORE_ACTIONS'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(40329256648866153)
,p_button_image_alt=>'More Actions'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P105_CARD_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_button_css_classes=>'ACTION_MENU TRANSPARENT'
,p_icon_css_classes=>'fa-ellipsis-h'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(46710585796930484)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_button_name=>'HELP'
,p_button_static_id=>'HELP_BUTTON'
,p_button_action=>'REDIRECT_APP'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(40329256648866153)
,p_button_image_alt=>'Help'
,p_button_position=>'UP'
,p_button_redirect_url=>'f?p=800:980:&SESSION.::&DEBUG.:980:P980_APP_ID,P980_PAGE_ID:&APP_ID.,&APP_PAGE_ID.'
,p_button_css_classes=>'TRANSPARENT'
,p_icon_css_classes=>'fa-question'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44437645857991804)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_button_name=>'CLOSE_DIALOG'
,p_button_static_id=>'CLOSE_DIALOG'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(40329256648866153)
,p_button_image_alt=>'Close Dialog'
,p_button_position=>'UP'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(44449860987991833)
,p_branch_name=>'GOTO_PREV_CARD'
,p_branch_action=>'f?p=&APP_ID.:105:&SESSION.::&DEBUG.:105:P105_CARD_ID:&P105_PREV_CARD_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(44438472867991804)
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(44450255523991834)
,p_branch_name=>'GOTO_NEXT_CARD'
,p_branch_action=>'f?p=&APP_ID.:105:&SESSION.::&DEBUG.:105:P105_CARD_ID:&P105_NEXT_CARD_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(44438034661991804)
,p_branch_sequence=>20
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(44449498466991833)
,p_branch_name=>'CREATE_ANOTHER'
,p_branch_action=>'f?p=&APP_ID.:105:&SESSION.::&DEBUG.:105:P105_STATUS_REQUESTED:&P105_STATUS_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(44434057267991801)
,p_branch_sequence=>30
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(44450627001991834)
,p_branch_name=>'GOTO_NEW_CARD'
,p_branch_action=>'f?p=&APP_ID.:105:&SESSION.::&DEBUG.:105:P105_CARD_ID:&P105_CARD_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>40
,p_branch_condition_type=>'REQUEST_IN_CONDITION'
,p_branch_condition=>'SPLIT_CARD,DUPLICATE_CARD'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(45572269247778841)
,p_branch_name=>'GOTO_CARDS_ON_AUTH_FAIL'
,p_branch_action=>'f?p=&APP_ID.:100:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_HEADER'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'NOT_EXISTS'
,p_branch_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1',
'FROM DUAL',
'WHERE (:P105_CARD_ID IS NULL OR EXISTS (',
'    SELECT 1',
'    FROM tsk_p100_cards_v t',
'    WHERE t.card_id = :P105_CARD_ID',
'));'))
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35710731373708550)
,p_name=>'P105_DISABLE_PREV'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40889118601180301)
,p_name=>'P105_DISABLE_NEXT'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44656592318008152)
,p_name=>'P105_CARD_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Card Number'
,p_source=>'CARD_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>16
,p_begin_on_new_line=>'N'
,p_grid_column=>4
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44657769548008164)
,p_name=>'P105_TAGS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(47449644132141587)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Tags'
,p_source=>'TAGS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>256
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_required_patch=>wwv_flow_imp.id(52968514038267289)
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44659415494008181)
,p_name=>'P105_CARD_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_source=>'CARD_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44659764638008184)
,p_name=>'P105_CARD_DESC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(44657546241008162)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Card Desc'
,p_source=>'CARD_DESC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'MARKDOWN'
,p_attribute_04=>'400'
,p_attribute_25=>'TINYMCE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44659833598008185)
,p_name=>'P105_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44659988413008186)
,p_name=>'P105_CREATED_AT'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Created by &P105_CREATED_BY.'
,p_format_mask=>'YYYY-MM-DD HH24:MI'
,p_source=>'CREATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45572366120778842)
,p_name=>'P105_SEQUENCE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Sequence'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_SEQUENCES'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(46409812269872743)
,p_name=>'P105_CATEGORY_JSON'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(44244095566877278)
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(46771672915419239)
,p_name=>'P105_STATUS_REQUESTED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(44244095566877278)
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47609132967111478)
,p_name=>'P105_BADGE_REVIEW'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56902590462100348)
,p_name=>'P105_COMMENT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(44242736402877265)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_tag_attributes=>'style="margin-bottom: 1rem;"'
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'Y'
,p_attribute_04=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56903358812100356)
,p_name=>'P105_COMMENT_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(44242736402877265)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56903775301100360)
,p_name=>'P105_MERGE_URL'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56905714773100380)
,p_name=>'P105_MERGE_CARD'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59202840303962156)
,p_name=>'P105_FILE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(109797893066546685)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99094505781454382)
,p_name=>'P105_CARD_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Card Name'
,p_source=>'CARD_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>128
,p_field_template=>wwv_flow_imp.id(40328770569866151)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99094724646454384)
,p_name=>'P105_BOARD_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Board'
,p_source=>'BOARD_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TSK_BOARDS'
,p_lov_cascade_parent_items=>'P105_PROJECT_ID'
,p_ajax_items_to_submit=>'P105_CLIENT_ID,P105_PROJECT_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(40328770569866151)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99094799557454385)
,p_name=>'P105_CLIENT_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_source=>'CLIENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99094935860454386)
,p_name=>'P105_PROJECT_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_source=>'PROJECT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99095029762454387)
,p_name=>'P105_SWIMLANE_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Swimlane'
,p_source=>'SWIMLANE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_SWIMLANES'
,p_lov_cascade_parent_items=>'P105_BOARD_ID'
,p_ajax_items_to_submit=>'P105_CLIENT_ID,P105_PROJECT_ID,P105_BOARD_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(40328770569866151)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99095180719454388)
,p_name=>'P105_STATUS_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Status'
,p_source=>'STATUS_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_STATUSES'
,p_lov_cascade_parent_items=>'P105_PROJECT_ID'
,p_ajax_items_to_submit=>'P105_CLIENT_ID,P105_PROJECT_ID,P105_BOARD_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(40328770569866151)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99095267928454389)
,p_name=>'P105_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99095454831454391)
,p_name=>'P105_ORDER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_source=>'ORDER#'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99265766147776597)
,p_name=>'P105_SOURCE_PAGE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(108407578727288808)
,p_name=>'P105_BADGE_DESC'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(108407679377288809)
,p_name=>'P105_BADGE_FILES'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(108407745145288810)
,p_name=>'P105_BADGE_COMMENTS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(108482785959625464)
,p_name=>'P105_BADGE_COMMITS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(108482874356625465)
,p_name=>'P105_BADGE_CHECKLIST'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(108485297621625490)
,p_name=>'P105_PREV_CARD_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(108485464892625491)
,p_name=>'P105_NEXT_CARD_ID'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(108485860898625495)
,p_name=>'P105_CARD_LINK'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(109589726837168694)
,p_name=>'P105_ATTACHED_FILES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(109797893066546685)
,p_prompt=>'Attach Files'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(40327394457866146)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attribute_01=>'APEX_APPLICATION_TEMP_FILES'
,p_attribute_09=>'SESSION'
,p_attribute_10=>'Y'
,p_attribute_12=>'DROPZONE_BLOCK'
,p_attribute_14=>'Select or drop one or more files here...'
,p_attribute_15=>'20000'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(110191650231252382)
,p_name=>'P105_UPDATED_AT'
,p_source_data_type=>'DATE'
,p_is_query_only=>true
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Updated by &P105_UPDATED_BY.'
,p_format_mask=>'YYYY-MM-DD HH24:MI'
,p_source=>'UPDATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(111515116872661671)
,p_name=>'P105_CATEGORY_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Category'
,p_source=>'CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_CATEGORIES'
,p_lov_cascade_parent_items=>'P105_PROJECT_ID'
,p_ajax_items_to_submit=>'P105_CLIENT_ID,P105_PROJECT_ID,P105_BOARD_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(40328770569866151)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(111875174773942889)
,p_name=>'P105_OWNER_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_default=>'core.get_user_id()'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'Owner'
,p_source=>'OWNER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_USERS'
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P105_BOARD_ID'
,p_ajax_items_to_submit=>'P105_CLIENT_ID,P105_PROJECT_ID,P105_BOARD_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(111875269860942890)
,p_name=>'P105_DEADLINE_AT'
,p_source_data_type=>'DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_item_source_plug_id=>wwv_flow_imp.id(127494684967555269)
,p_prompt=>'Deadline At'
,p_format_mask=>'YYYY-MM-DD'
,p_source=>'DEADLINE_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(40327496873866147)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'NATIVE'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(112052362987337663)
,p_name=>'P105_BADGE_TAGS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(127526930346555355)
,p_name=>'P105_HEADER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(127494529654555268)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(46409888497872744)
,p_computation_sequence=>10
,p_computation_item=>'P105_CATEGORY_JSON'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT JSON_ARRAY(JSON_OBJECTAGG (',
'        KEY t.category_id VALUE t.color_bg',
'    ))',
'FROM tsk_lov_categories_v t;'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(46772187066419244)
,p_name=>'REQUESTED_STATUS'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P105_STATUS_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
,p_display_when_type=>'ITEM_IS_NULL'
,p_display_when_cond=>'P105_CARD_ID'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(46771885281419241)
,p_event_id=>wwv_flow_imp.id(46772187066419244)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.item(''P105_STATUS_ID'').setValue(apex.item(''P105_STATUS_REQUESTED'').getValue());'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(56902627292100349)
,p_name=>'DELETE_COMMENT'
,p_event_sequence=>10
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'document'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'DELETE_COMMENT'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56903235833100355)
,p_event_id=>wwv_flow_imp.id(56902627292100349)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P105_CARD_ID'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.card_id'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
,p_server_condition_type=>'NEVER'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56903070776100353)
,p_event_id=>wwv_flow_imp.id(56902627292100349)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P105_COMMENT_ID'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.comment_id'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56902911510100351)
,p_event_id=>wwv_flow_imp.id(56902627292100349)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'tsk_p105.delete_comment (',
'    in_card_id      => :P105_CARD_ID,',
'    in_comment_id   => :P105_COMMENT_ID',
');'))
,p_attribute_02=>'P105_CARD_ID,P105_COMMENT_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56903494013100357)
,p_event_id=>wwv_flow_imp.id(56902627292100349)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'show_message(apex.item(''P105_COMMENT_MESSAGE'').getValue());'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56903114812100354)
,p_event_id=>wwv_flow_imp.id(56902627292100349)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(108451051217625384)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(59202219822962150)
,p_name=>'DELETE_FILE'
,p_event_sequence=>20
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'document'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'DELETE_FILE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(59202490865962152)
,p_event_id=>wwv_flow_imp.id(59202219822962150)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P105_FILE_ID'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.file_id'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(59202528209962153)
,p_event_id=>wwv_flow_imp.id(59202219822962150)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'tsk_p105.delete_file (',
'    in_file_id      => :P105_FILE_ID',
');'))
,p_attribute_02=>'P105_CARD_ID,P105_FILE_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(59202643641962154)
,p_event_id=>wwv_flow_imp.id(59202219822962150)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'show_message(''File deleted'');'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(59202746419962155)
,p_event_id=>wwv_flow_imp.id(59202219822962150)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(58942979295473085)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(56904470913100367)
,p_name=>'STACKED_MODAL_CLOSED'
,p_event_sequence=>30
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'window'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(57583920510687345)
,p_event_id=>wwv_flow_imp.id(56904470913100367)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'GET_MODAL_PAGE_NUMBER'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// detect which page closed',
'console.log(''MODAL_CLOSED'', this.data.dialogPageId);',
'//console.log(''MORE_INFO'', $(this.browserEvent.target).parent(), $(this.browserEvent.target).attr(''class''));  // we can check CSS class for example',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56906233329100385)
,p_event_id=>wwv_flow_imp.id(56904470913100367)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'GET_LINK_FROM_MODAL'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P105_MERGE_CARD'
,p_attribute_01=>'DIALOG_RETURN_ITEM'
,p_attribute_09=>'N'
,p_attribute_10=>'P108_TARGET_CARD_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(57583412717687340)
,p_event_id=>wwv_flow_imp.id(56904470913100367)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'REFRESH_PAGE_ITEM'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P105_MERGE_CARD'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56904817266100371)
,p_event_id=>wwv_flow_imp.id(56904470913100367)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'REDIRECT_TO_NEW_PAGE'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'show_success(''Cards merged.'');',
'apex.navigation.redirect(apex.item(''P105_MERGE_CARD'').getValue());',
''))
,p_client_condition_type=>'NOT_NULL'
,p_client_condition_element=>'P105_MERGE_CARD'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(58194031704082660)
,p_name=>'RENUMBER_CHECKLIST'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(110541566711018499)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'NATIVE_IG|REGION TYPE|apexbeginrecordedit'
,p_display_when_type=>'NEVER'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(58194148033082661)
,p_event_id=>wwv_flow_imp.id(58194031704082660)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'console.log(''NEW_ROW_INIT'');'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(58195130453082671)
,p_name=>'CREATE_CARD_AND_CLOSE'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(44434430741991801)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(58195262295082672)
,p_event_id=>wwv_flow_imp.id(58195130453082671)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'submit_checklist(this.triggeringElement.id);'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(58195354001082673)
,p_name=>'CREATE_CARD'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(57584109329687346)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(58195456209082674)
,p_event_id=>wwv_flow_imp.id(58195354001082673)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'submit_checklist(this.triggeringElement.id);'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(58195572399082675)
,p_name=>'CREATE_ANOTHER'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(44434057267991801)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(58195694256082676)
,p_event_id=>wwv_flow_imp.id(58195572399082675)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'submit_checklist(this.triggeringElement.id);'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(46018197822168178)
,p_name=>'UPDATE_AND_REFRESH'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(46018001553168176)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(46018265576168179)
,p_event_id=>wwv_flow_imp.id(46018197822168178)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'submit_checklist(this.triggeringElement.id);'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(46409417036872740)
,p_name=>'CHANGED_CATEGORY'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P105_CATEGORY_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(46409550009872741)
,p_event_id=>wwv_flow_imp.id(46409417036872740)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// change styles',
'var color_map   = JSON.parse(apex.item(''P105_CATEGORY_JSON'').getValue())[0];',
'var category_id = apex.item(''P105_CATEGORY_ID'').getValue();',
'var color       = color_map[category_id];',
'//',
'if (color && color.length > 0) {',
'    $(''select#P105_CATEGORY_ID'').css(''border-left'', ''8px solid '' + color);',
'    $(''label#P105_CATEGORY_ID_LABEL'').css(''padding-left'', ''0.95rem'');',
'}',
'else {',
'    $(''select#P105_CATEGORY_ID'').css(''border-left'', ''1px solid var(--a-field-input-state-border-color,var(--a-field-input-border-color))'');',
'    $(''label#P105_CATEGORY_ID_LABEL'').css(''padding-left'', ''0.5rem'');',
'}',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(58194916320082669)
,p_name=>'UPDATE_CARD_AND_CLOSE'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(44434883474991801)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(58195110930082670)
,p_event_id=>wwv_flow_imp.id(58194916320082669)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'submit_checklist(this.triggeringElement.id);'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(44430594589991795)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'SAVE_FORM'
,p_attribute_01=>'PLSQL_PACKAGE'
,p_attribute_03=>'TSK_P105'
,p_attribute_04=>'SAVE_CARD'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'&P0_SUCCESS_MESSAGE.'
,p_internal_uid=>25252582106844557
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(44418292592991781)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(110541566711018499)
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'SAVE_CHECKLIST'
,p_attribute_01=>'PLSQL_PACKAGE'
,p_attribute_03=>'TSK_P105'
,p_attribute_04=>'SAVE_CHECKLIST'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>25240280109844543
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(44443835326991825)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'CLOSE_DIALOG'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'core.get_request() LIKE ''%\_CLOSE'' ESCAPE ''\'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_process_success_message=>'&P0_SUCCESS_MESSAGE.'
,p_internal_uid=>25265822843844587
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(44430140872991795)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(127494684967555269)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'INIT_FORM'
,p_process_when=>'P105_CARD_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>25252128389844557
);
wwv_flow_imp.component_end;
end;
/
