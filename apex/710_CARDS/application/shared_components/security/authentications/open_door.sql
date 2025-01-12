prompt --application/shared_components/security/authentications/open_door
begin
--   Manifest
--     AUTHENTICATION: OPEN_DOOR
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(39942195226197542)
,p_name=>'OPEN_DOOR'
,p_scheme_type=>'NATIVE_OPEN_DOOR'
,p_logout_url=>'f?p=800:9999:0'
,p_cookie_name=>'&WORKSPACE_COOKIE.'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_switch_in_session_yn=>'Y'
,p_reference_id=>13156773430345572
,p_version_scn=>42101120134023
);
wwv_flow_imp.component_end;
end;
/
