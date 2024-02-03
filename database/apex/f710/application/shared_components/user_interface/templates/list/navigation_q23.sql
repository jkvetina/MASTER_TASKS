prompt --application/shared_components/user_interface/templates/list/navigation_q23
begin
--   Manifest
--     REGION TEMPLATE: NAVIGATION_Q23
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_list_template(
 p_id=>wwv_flow_imp.id(31684266225644159)
,p_list_template_current=>'#A08#<li #A10#>#A01##A02##A03##A04##A05##A06##A07#</li>#A09#'
,p_list_template_noncurrent=>'#A08#<li #A10#>#A01##A02##A03##A04##A05##A06##A07#</li>#A09#'
,p_list_template_name=>'Navigation Q23'
,p_internal_name=>'NAVIGATION_Q23'
,p_theme_id=>800
,p_theme_class_id=>20
,p_list_template_before_rows=>'<ul class="LEFT">'
,p_list_template_after_rows=>'</ul>'
,p_before_sub_list=>'<div class="WRAPPER"><div class="COLUMNS"><ul>'
,p_after_sub_list=>'</ul></div></div></li>'
,p_sub_list_item_current=>'#A08#<li #A10#>#A01##A02##A03##A04##A05##A06##A07#</li>#A09#'
,p_sub_list_item_noncurrent=>'#A08#<li #A10#>#A01##A02##A03##A04##A05##A06##A07#</li>#A09#'
,p_item_templ_curr_w_child=>'#A08#<li #A10#>#A01##A02##A03##A04##A05##A06##A07#'
,p_item_templ_noncurr_w_child=>'#A08#<li #A10#>#A01##A02##A03##A04##A05##A06##A07#'
,p_sub_templ_curr_w_child=>'#A08#<li #A10#>#A01##A02##A03##A04##A05##A06##A07#'
,p_sub_templ_noncurr_w_child=>'#A08#<li #A10#>#A01##A02##A03##A04##A05##A06##A07#'
,p_a01_label=>'CONTENT INSIDE <li>'
,p_a08_label=>'BEFORE <li>'
,p_a09_label=>'AFTER <li>'
,p_a10_label=>'PARAMETERS IN <li>  // class="", style=""...'
,p_reference_id=>28883453409606801
);
wwv_flow_imp.component_end;
end;
/
