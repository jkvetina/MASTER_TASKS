prompt --application/shared_components/security/authorizations/master_is_admin
begin
--   Manifest
--     SECURITY SCHEME: MASTER - IS_ADMIN
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.2'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(70314575553792528)  -- MASTER - IS_ADMIN
,p_name=>'MASTER - IS_ADMIN'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>'RETURN app_auth.is_admin() = ''Y'';'
,p_error_message=>'ACCESS_DENIED|IS_ADMIN'
,p_reference_id=>63924538900170215
,p_caching=>'BY_USER_BY_PAGE_VIEW'
,p_comments=>'This needs to be relevant to active application'
);
wwv_flow_imp.component_end;
end;
/
