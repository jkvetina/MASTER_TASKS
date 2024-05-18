prompt --application/shared_components/security/authorizations/master_nobody
begin
--   Manifest
--     SECURITY SCHEME: MASTER - NOBODY
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(63487399953980290)  -- AUTHORIZATION: MASTER - NOBODY
,p_name=>'MASTER - NOBODY'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>'RETURN FALSE;'
,p_reference_id=>55122406216768269
,p_caching=>'BY_USER_BY_SESSION'
,p_comments=>'This is an alternative to build option Never and/or server side condition Never so you can keep values there'
);
wwv_flow_imp.component_end;
end;
/
