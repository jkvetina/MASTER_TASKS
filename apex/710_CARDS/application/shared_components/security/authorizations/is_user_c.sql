prompt --application/shared_components/security/authorizations/is_user_c
begin
--   Manifest
--     SECURITY SCHEME: IS_USER_C
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
 p_id=>wwv_flow_imp.id(39923772794197491)  -- AUTHORIZATION: IS_USER_C
,p_name=>'IS_USER_C'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN app_auth.is_user_component (',
'    in_component_id     => :APP_COMPONENT_ID,',
'    in_component_type   => :APP_COMPONENT_TYPE,',
'    in_component_name   => :APP_COMPONENT_NAME,',
'    in_action           => ''C''',
') = ''Y'';'))
,p_error_message=>'ACCESS_DENIED|IS_USER_C'
,p_reference_id=>39917183273113133
,p_version_scn=>42190236125622
,p_caching=>'NOCACHE'
);
wwv_flow_imp.component_end;
end;
/
