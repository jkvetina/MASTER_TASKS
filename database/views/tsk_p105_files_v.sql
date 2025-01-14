CREATE OR REPLACE FORCE VIEW tsk_p105_files_v AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        t.card_id,
        core.get_user_id()              AS user_id
    FROM tsk_p100_cards_v t
    WHERE t.card_id = core.get_number_item('$CARD_ID')
)
SELECT
    -- https://apex.oracle.com/pls/apex/apex_pm/r/ut/comments-report
    c.card_id,
    c.file_id       AS comment_id,
    --
    CASE
        WHEN c.updated_by = x.user_id
            THEN '<span class="fa fa-trash-o" style="color: gray !important; font-size: 100%;"></span>'
        END AS actions,
    --
    '' AS attribute_1,
    '' AS attribute_2,
    '' AS attribute_3,
    '' AS attribute_4,
    --
    CASE WHEN c.updated_at < TRUNC(SYSDATE)
        THEN TO_CHAR(c.updated_at, 'YYYY-MM-DD HH24:MI')
        ELSE APEX_UTIL.GET_SINCE(c.updated_at)
        END AS comment_date,
    --
    CASE WHEN c.updated_by != x.user_id
        THEN 'OTHERS'
        END AS comment_modifiers,
    --
    '<a href="' || APEX_PAGE.GET_URL(
        p_page      => 106,
        p_items     => 'P106_FILE_ID',
        p_values    => '' || c.file_id
    ) || '">' || c.file_name ||
    '</a><span class="GREY"> &' || 'nbsp;' ||
    TRANSLATE(APEX_STRING_UTIL.TO_DISPLAY_FILESIZE(c.file_size), 'K', 'k') ||
    '</span>' AS comment_text,
    --
    --'u-color-' || ORA_HASH(c.updated_by, 45) AS icon_modifier,
    CASE WHEN c.updated_by = x.user_id
        THEN ''
        END AS icon_modifier,
    --
    app.get_user_name(c.updated_by) AS user_icon,
    app.get_user_name(c.updated_by) AS user_name,
    --
    ROW_NUMBER() OVER (ORDER BY c.card_id, c.updated_at DESC) AS order#
    --
FROM tsk_card_files c
JOIN x
    ON x.card_id = c.card_id;
/

