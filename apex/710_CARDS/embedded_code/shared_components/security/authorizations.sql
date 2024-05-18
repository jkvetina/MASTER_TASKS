-- ----------------------------------------
-- Authorization: MASTER - IS_ADMIN > Settings > PL/SQL Function Body

RETURN app_auth.is_admin() = 'Y';

-- ----------------------------------------
-- Authorization: MASTER - IS_DEVELOPER > Settings > PL/SQL Function Body

RETURN core.is_developer();

-- ----------------------------------------
-- Authorization: MASTER - IS_USER > Settings > PL/SQL Function Body

RETURN app_auth.is_user() = 'Y';

-- ----------------------------------------
-- Authorization: MASTER - IS_USER_C > Settings > PL/SQL Function Body

RETURN app_auth.is_user_component (
    in_component_id     => :APP_COMPONENT_ID,
    in_component_type   => :APP_COMPONENT_TYPE,
    in_component_name   => :APP_COMPONENT_NAME,
    in_action           => 'C'
) = 'Y';

-- ----------------------------------------
-- Authorization: MASTER - IS_USER_COMPONENT > Settings > PL/SQL Function Body

RETURN app_auth.is_user_component (
    in_component_id     => :APP_COMPONENT_ID,
    in_component_type   => :APP_COMPONENT_TYPE,
    in_component_name   => :APP_COMPONENT_NAME,
    in_action           => NULL
) = 'Y';

-- ----------------------------------------
-- Authorization: MASTER - IS_USER_D > Settings > PL/SQL Function Body

RETURN app_auth.is_user_component (
    in_component_id     => :APP_COMPONENT_ID,
    in_component_type   => :APP_COMPONENT_TYPE,
    in_component_name   => :APP_COMPONENT_NAME,
    in_action           => 'D'
) = 'Y';

-- ----------------------------------------
-- Authorization: MASTER - IS_USER_U > Settings > PL/SQL Function Body

RETURN app_auth.is_user_component (
    in_component_id     => :APP_COMPONENT_ID,
    in_component_type   => :APP_COMPONENT_TYPE,
    in_component_name   => :APP_COMPONENT_NAME,
    in_action           => 'U'
) = 'Y';

-- ----------------------------------------
-- Authorization: MASTER - NOBODY > Settings > PL/SQL Function Body

RETURN FALSE;

