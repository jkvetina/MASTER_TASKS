prompt --application/shared_components/security/authorizations/master_is_user_component
begin
--   Manifest
--     SECURITY SCHEME: MASTER - IS_USER_COMPONENT
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(34516818971352065)  -- MASTER - IS_USER_COMPONENT
,p_name=>'MASTER - IS_USER_COMPONENT'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN app_auth.is_user_component (',
'    in_component_id     => :APP_COMPONENT_ID,',
'    in_component_type   => :APP_COMPONENT_TYPE,',
'    in_component_name   => :APP_COMPONENT_NAME,',
'    in_action           => NULL',
') = ''Y'';'))
,p_error_message=>'ACCESS_DENIED|IS_USER_COMPONENT'
,p_reference_id=>14635437545348202
,p_caching=>'NOCACHE'
);
wwv_flow_imp.component_end;
end;
/
