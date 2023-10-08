BEGIN
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- MERGE ' || UPPER('app_navigation'));
    DBMS_OUTPUT.PUT_LINE('--');
END;
/
--
DELETE FROM app_navigation
WHERE app_id = 710;
--
MERGE INTO app_navigation t
USING (
    SELECT 710 AS app_id, 0 AS page_id, NULL AS parent_id, NULL AS is_hidden, NULL AS is_reset, 666 AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 100 AS page_id, NULL AS parent_id, NULL AS is_hidden, NULL AS is_reset, 1 AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 105 AS page_id, 100 AS parent_id, 'Y' AS is_hidden, 'Y' AS is_reset, NULL AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 200 AS page_id, NULL AS parent_id, NULL AS is_hidden, 'Y' AS is_reset, 200 AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 210 AS page_id, 200 AS parent_id, NULL AS is_hidden, 'Y' AS is_reset, 10 AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 300 AS page_id, NULL AS parent_id, NULL AS is_hidden, 'Y' AS is_reset, 300 AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 310 AS page_id, 300 AS parent_id, NULL AS is_hidden, 'Y' AS is_reset, 10 AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 320 AS page_id, 300 AS parent_id, NULL AS is_hidden, 'Y' AS is_reset, 15 AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 340 AS page_id, 300 AS parent_id, NULL AS is_hidden, 'Y' AS is_reset, 20 AS order#, NULL AS col_id FROM DUAL UNION ALL
    SELECT 710 AS app_id, 400 AS page_id, NULL AS parent_id, NULL AS is_hidden, 'Y' AS is_reset, 400 AS order#, NULL AS col_id FROM DUAL
) s
ON (
    t.app_id = s.app_id
    AND t.page_id = s.page_id
)
--WHEN MATCHED THEN
--    UPDATE SET
--        t.parent_id = s.parent_id,
--        t.is_hidden = s.is_hidden,
--        t.is_reset = s.is_reset,
--        t.order# = s.order#,
--        t.col_id = s.col_id
WHEN NOT MATCHED THEN
    INSERT (
        t.app_id,
        t.page_id,
        t.parent_id,
        t.is_hidden,
        t.is_reset,
        t.order#,
        t.col_id
    )
    VALUES (
        s.app_id,
        s.page_id,
        s.parent_id,
        s.is_hidden,
        s.is_reset,
        s.order#,
        s.col_id
    );
