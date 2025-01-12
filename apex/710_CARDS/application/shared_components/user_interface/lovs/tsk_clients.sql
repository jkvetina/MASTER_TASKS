prompt --application/shared_components/user_interface/lovs/tsk_clients
begin
--   Manifest
--     TSK_CLIENTS
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
 p_id=>wwv_flow_imp.id(39095152206102634)  -- LOV: TSK_CLIENTS
,p_lov_name=>'TSK_CLIENTS'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'TSK_LOV_CLIENTS_V'
,p_return_column_name=>'CLIENT_ID'
,p_display_column_name=>'CLIENT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'ORDER#'
,p_default_sort_direction=>'ASC'
,p_version_scn=>42190258826652
);
wwv_flow_imp.component_end;
end;
/
