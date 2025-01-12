prompt --application/shared_components/security/authorizations/is_admin
begin
--   Manifest
--     SECURITY SCHEME: IS_ADMIN
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'MASTER'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(39924937074197493)  -- AUTHORIZATION: IS_ADMIN
,p_name=>'IS_ADMIN'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>'RETURN master.app_auth.is_admin() = ''Y'';'
,p_error_message=>'ACCESS_DENIED|IS_ADMIN'
,p_reference_id=>15176840787568678
,p_version_scn=>42190236118045
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
wwv_flow_imp.component_end;
end;
/
