prompt --application/deployment/definition
begin
--   Manifest
--     INSTALL: 710
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.3'
,p_default_workspace_id=>13869170895410902
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_install(
 p_id=>wwv_flow_imp.id(34526756995577240)
);
wwv_flow_imp.component_end;
end;
/