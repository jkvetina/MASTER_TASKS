-- ----------------------------------------
-- Page: 105 - Card Detail > Region: Files [REPORT] > Server-side Condition (Rows returned) > SQL Query

SELECT 1
FROM tsk_p105_files_v
WHERE ROWNUM = 1;

-- ----------------------------------------
-- Page: 105 - Card Detail > Branch: GOTO_CARDS_ON_AUTH_FAIL > Server-side Condition (No Rows returned) > SQL Query

SELECT 1
FROM DUAL
WHERE (:P105_CARD_ID IS NULL OR EXISTS (
    SELECT 1
    FROM tsk_p100_cards_v t
    WHERE t.card_id = :P105_CARD_ID
));

-- ----------------------------------------
-- Page: 105 - Card Detail > Computation: P105_CATEGORY_JSON > Computation > SQL Query

SELECT JSON_ARRAY(JSON_OBJECTAGG (
        KEY t.category_id VALUE t.color_bg
    ))
FROM tsk_lov_categories_v t;

-- ----------------------------------------
-- Page: 105 - Card Detail > Dynamic Action: DELETE_COMMENT > Action: Execute Server-side Code > Settings > PL/SQL Code

tsk_p105.delete_comment (
    in_card_id      => :P105_CARD_ID,
    in_comment_id   => :P105_COMMENT_ID
);

-- ----------------------------------------
-- Page: 105 - Card Detail > Dynamic Action: DELETE_FILE > Action: Execute Server-side Code > Settings > PL/SQL Code

tsk_p105.delete_file (
    in_file_id      => :P105_FILE_ID
);

