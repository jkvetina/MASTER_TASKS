CREATE OR REPLACE FORCE VIEW tsk_lov_users_v AS
SELECT
    t.user_id,
    t.user_mail,
    t.user_name,
    --
    NVL(t.user_name, t.user_id) || ' (' || t.user_mail || ')' AS user_name__
    --
FROM app_users_v t
WHERE t.is_active       = 'Y';
--
COMMENT ON TABLE tsk_lov_users_v IS '';

