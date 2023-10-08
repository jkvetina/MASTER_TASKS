prompt --application/shared_components/user_interface/lovs/lov_repo_owners
begin
--   Manifest
--     LOV_REPO_OWNERS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.2'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(26958162062151510)  -- LOV_REPO_OWNERS
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
);
wwv_flow_imp.component_end;
end;
/
