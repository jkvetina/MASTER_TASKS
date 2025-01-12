-- ----------------------------------------
-- Application Process: AFTER_AUTH > Source > PL/SQL Code

master.app_auth.after_auth();

-- ----------------------------------------
-- Application Process: AJAX_FAVORITE_SWITCH > Source > PL/SQL Code

app.favorite_switch (
    in_app_id           => APEX_APPLICATION.G_X01,
    in_page_id          => APEX_APPLICATION.G_X02,
    in_element_id       => APEX_APPLICATION.G_X03,
    in_favorite_type    => APEX_APPLICATION.G_X04,
    in_favorite_id      => APEX_APPLICATION.G_X05
);

-- ----------------------------------------
-- Application Process: AJAX_PING > Source > PL/SQL Code

master.app.ajax_ping();

-- ----------------------------------------
-- Application Process: FIX_FIRST_MESSAGE > Source > PL/SQL Code

-- intercept message injected on page (typically after page submit)
APEX_JAVASCRIPT.ADD_INLINE_CODE (
    p_code => '
var message = $("#APEX_SUCCESS_MESSAGE .t-Alert-content h2.t-Alert-title").text();
if (message.trim().length > 0) {
    console.log("MESSAGE INTERCEPTED", message);
    $("#APEX_SUCCESS_MESSAGE").html("");
    apex.jQuery(window).on("theme42ready", function() {
        show_success(message);
    });
}'
);

-- ----------------------------------------
-- Application Process: INIT_DEFAULTS > Source > PL/SQL Code

master.app.init_defaults();

