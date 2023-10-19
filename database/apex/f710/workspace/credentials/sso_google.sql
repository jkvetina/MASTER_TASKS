prompt --workspace/credentials/sso_google
begin
--   Manifest
--     CREDENTIAL: SSO_GOOGLE
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.5'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>19878674458876767
,p_default_owner=>'APPS'
);
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(62013508289982337)
,p_name=>'SSO_GOOGLE'
,p_static_id=>'SSO_GOOGLE'
,p_authentication_type=>'OAUTH2_CLIENT_CREDENTIALS'
,p_prompt_on_install=>true
);
wwv_flow_imp.component_end;
end;
/
