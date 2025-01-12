prompt --application/shared_components/logic/application_processes/fix_first_message
begin
--   Manifest
--     APPLICATION PROCESS: FIX_FIRST_MESSAGE
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.4'
,p_default_workspace_id=>1000000000000
,p_default_application_id=>710
,p_default_id_offset=>0
,p_default_owner=>'APPS'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(39944637886197552)
,p_process_sequence=>-10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'FIX_FIRST_MESSAGE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- intercept message injected on page (typically after page submit)',
'APEX_JAVASCRIPT.ADD_INLINE_CODE (',
'    p_code => ''',
'var message = $("#APEX_SUCCESS_MESSAGE .t-Alert-content h2.t-Alert-title").text();',
'if (message.trim().length > 0) {',
'    console.log("MESSAGE INTERCEPTED", message);',
'    $("#APEX_SUCCESS_MESSAGE").html("");',
'    apex.jQuery(window).on("theme42ready", function() {',
'        show_success(message);',
'    });',
'}''',
');'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_reference_id=>14981262570116587
,p_version_scn=>42188994139633
);
wwv_flow_imp.component_end;
end;
/
