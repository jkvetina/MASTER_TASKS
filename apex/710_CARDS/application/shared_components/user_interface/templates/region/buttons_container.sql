prompt --application/shared_components/user_interface/templates/region/buttons_container
begin
--   Manifest
--     REGION TEMPLATE: BUTTONS_CONTAINER
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_plug_template(
 p_id=>wwv_flow_imp.id(33884050069153737)
,p_layout=>'TABLE'
,p_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-ButtonRegion t-Form--floatLeft #REGION_CSS_CLASSES#" id="#REGION_STATIC_ID#" #REGION_LANDMARK_ATTRIBUTES# #REGION_ATTRIBUTES#>',
'  <div class="t-ButtonRegion-wrap">',
'    <div class="t-ButtonRegion-col t-ButtonRegion-col--left"><div class="t-ButtonRegion-buttons">#PREVIOUS##CLOSE##DELETE#</div></div>',
'    <div class="t-ButtonRegion-col t-ButtonRegion-col--content">',
'      #BODY#',
'      <div class="t-ButtonRegion-buttons">#CHANGE#</div>',
'      #SUB_REGIONS#',
'    </div>',
'    <div class="t-ButtonRegion-col t-ButtonRegion-col--right"><div class="t-ButtonRegion-buttons">#EDIT##CREATE##NEXT#</div></div>',
'  </div>',
'</div>'))
,p_page_plug_template_name=>'Buttons Container'
,p_internal_name=>'BUTTONS_CONTAINER'
,p_plug_table_bgcolor=>'#ffffff'
,p_theme_id=>800
,p_theme_class_id=>17
,p_plug_heading_bgcolor=>'#ffffff'
,p_plug_font_size=>'-1'
,p_default_label_alignment=>'RIGHT'
,p_default_field_alignment=>'LEFT'
,p_default_landmark_type=>'region'
,p_reference_id=>63380428289439110
,p_translate_this_template=>'N'
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35172047842125404)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Region Body'
,p_placeholder=>'BODY'
,p_has_grid_support=>true
,p_has_region_support=>true
,p_has_item_support=>true
,p_has_button_support=>true
,p_glv_new_row=>true
,p_max_fixed_grid_columns=>12
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35172565378125404)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Change'
,p_placeholder=>'CHANGE'
,p_has_grid_support=>false
,p_has_region_support=>false
,p_has_item_support=>true
,p_has_button_support=>true
,p_glv_new_row=>true
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35173073331125404)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Close'
,p_placeholder=>'CLOSE'
,p_has_grid_support=>false
,p_has_region_support=>false
,p_has_item_support=>false
,p_has_button_support=>true
,p_glv_new_row=>true
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35173557996125405)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Create'
,p_placeholder=>'CREATE'
,p_has_grid_support=>false
,p_has_region_support=>false
,p_has_item_support=>false
,p_has_button_support=>true
,p_glv_new_row=>true
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35174031438125405)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Delete'
,p_placeholder=>'DELETE'
,p_has_grid_support=>false
,p_has_region_support=>false
,p_has_item_support=>false
,p_has_button_support=>true
,p_glv_new_row=>true
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35174594275125405)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Edit'
,p_placeholder=>'EDIT'
,p_has_grid_support=>false
,p_has_region_support=>false
,p_has_item_support=>false
,p_has_button_support=>true
,p_glv_new_row=>true
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35175084419125406)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Next'
,p_placeholder=>'NEXT'
,p_has_grid_support=>false
,p_has_region_support=>false
,p_has_item_support=>true
,p_has_button_support=>true
,p_glv_new_row=>true
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35175548698125406)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Previous'
,p_placeholder=>'PREVIOUS'
,p_has_grid_support=>false
,p_has_region_support=>false
,p_has_item_support=>true
,p_has_button_support=>true
,p_glv_new_row=>true
);
wwv_flow_imp_shared.create_plug_tmpl_display_point(
 p_id=>wwv_flow_imp.id(35176062410125406)
,p_plug_template_id=>wwv_flow_imp.id(33884050069153737)
,p_name=>'Sub Regions'
,p_placeholder=>'SUB_REGIONS'
,p_has_grid_support=>true
,p_has_region_support=>true
,p_has_item_support=>false
,p_has_button_support=>false
,p_glv_new_row=>true
,p_max_fixed_grid_columns=>12
);
wwv_flow_imp.component_end;
end;
/
