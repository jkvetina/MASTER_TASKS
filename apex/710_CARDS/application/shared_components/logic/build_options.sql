prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 710
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'MASTER'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(52968514038267289)
,p_build_option_name=>'NEVER'
,p_build_option_status=>'EXCLUDE'
,p_reference_id=>13997038230229689
,p_version_scn=>42101049256871
,p_default_on_export=>'EXCLUDE'
,p_on_upgrade_keep_status=>true
);
wwv_flow_imp.component_end;
end;
/
