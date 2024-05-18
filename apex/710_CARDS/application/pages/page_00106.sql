prompt --application/pages/page_00106
begin
--   Manifest
--     PAGE: 00106
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_page.create_page(
 p_id=>106
,p_name=>'Download File'
,p_alias=>'DOWNLOAD-FILE'
,p_step_title=>'Download File'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(23490192563159466)  -- PAGE GROUP: 1) CARDS
,p_step_template=>wwv_flow_imp.id(33855748334153718)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(70314822393792529)  -- AUTHORIZATION: MASTER - IS_USER
,p_protection_level=>'C'
,p_page_component_map=>'11'
,p_last_updated_by=>'JAN.KVETINA@GMAIL.COM'
,p_last_upd_yyyymmddhh24miss=>'20231108144053'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(105412845587338237)
,p_name=>'P106_FILE_ID'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(40022146811783282)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DOWNLOAD_FILE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'tsk_p105.download_attachement (',
'    in_file_id => :P106_FILE_ID',
');'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>40022146811783282
);
wwv_flow_imp.component_end;
end;
/
