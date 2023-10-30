CREATE OR REPLACE FORCE VIEW tsk_lov_card_autocomplete_v AS
SELECT
    t.card_id,
    '#' || t.card_id || ' - ' || t.card_name AS card_name
    --
FROM tsk_cards t
JOIN tsk_available_boards_v a
    ON a.client_id      = t.client_id
    AND a.project_id    = t.project_id
    AND a.board_id      = t.board_id
    AND a.is_current    = 'Y';
--
COMMENT ON TABLE tsk_lov_card_autocomplete_v IS '';

