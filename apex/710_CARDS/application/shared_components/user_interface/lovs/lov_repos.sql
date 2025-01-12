prompt --application/shared_components/user_interface/lovs/lov_repos
begin
--   Manifest
--     LOV_REPOS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'MASTER'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(46135152335298738)  -- LOV: LOV_REPOS
,p_lov_name=>'LOV_REPOS'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'TSK_LOV_REPOS_V'
,p_return_column_name=>'REPO_ID'
,p_display_column_name=>'REPO_ID'
,p_group_column_name=>'OWNER_ID'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'REPO_ID'
,p_default_sort_direction=>'ASC'
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
