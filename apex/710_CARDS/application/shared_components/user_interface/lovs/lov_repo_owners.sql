prompt --application/shared_components/user_interface/lovs/lov_repo_owners
begin
--   Manifest
--     LOV_REPO_OWNERS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(46136174545298748)  -- LOV: LOV_REPO_OWNERS
,p_lov_name=>'LOV_REPO_OWNERS'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'TSK_LOV_REPO_OWNERS_V'
,p_return_column_name=>'OWNER_ID'
,p_display_column_name=>'OWNER_ID'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'OWNER_ID'
,p_default_sort_direction=>'ASC'
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
