prompt --application/shared_components/security/authorizations/is_user_u
begin
--   Manifest
--     SECURITY SCHEME: IS_USER_U
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(39926164959197496)  -- AUTHORIZATION: IS_USER_U
,p_name=>'IS_USER_U'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN app_auth.is_user_component (',
'    in_component_id     => :APP_COMPONENT_ID,',
'    in_component_type   => :APP_COMPONENT_TYPE,',
'    in_component_name   => :APP_COMPONENT_NAME,',
'    in_action           => ''U''',
') = ''Y'';'))
,p_error_message=>'ACCESS_DENIED|IS_USER_U'
,p_reference_id=>39918522071121241
,p_version_scn=>42190236130794
,p_caching=>'NOCACHE'
);
wwv_flow_imp.component_end;
end;
/