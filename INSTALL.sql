--
-- YOU HAVE TO INSTALL THE CORE PACKAGE FIRST
-- https://github.com/jkvetina/CORE23/tree/main/database
--
-- INDEX ................. 21
-- PACKAGE ................ 7
-- PACKAGE BODY ........... 7
-- SEQUENCE ............... 5
-- TABLE ................. 17
-- TRIGGER ............... 16
-- VIEW .................. 45

--
-- INIT
--
@@"./patches/10_init/01_init.sql"

--
-- SEQUENCES
--
@@"./database/sequences/tsk_board_id.sql"
@@"./database/sequences/tsk_card_id.sql"
@@"./database/sequences/tsk_checklist_id.sql"
@@"./database/sequences/tsk_comment_id.sql"
@@"./database/sequences/tsk_file_id.sql"

--
-- TABLES
--
@@"./database/tables/tsk_clients.sql"
@@"./database/tables/tsk_projects.sql"
@@"./database/tables/tsk_sequences.sql"
@@"./database/tables/tsk_repos.sql"
@@"./database/tables/tsk_statuses.sql"
@@"./database/tables/tsk_swimlanes.sql"
@@"./database/tables/tsk_categories.sql"
@@"./database/tables/tsk_boards.sql"
@@"./database/tables/tsk_commits.sql"
@@"./database/tables/tsk_repo_endpoints.sql"
@@"./database/tables/tsk_boards_fav.sql"
@@"./database/tables/tsk_recent.sql"
@@"./database/tables/tsk_cards.sql"
@@"./database/tables/tsk_card_checklist.sql"
@@"./database/tables/tsk_card_comments.sql"
@@"./database/tables/tsk_card_commits.sql"
@@"./database/tables/tsk_card_files.sql"

--
-- OBJECTS
--
@@"./patches/40_repeatable_objects/40_drop_objects.sql"
--
@@"./database/packages/tsk_handlers.spec.sql"
@@"./database/packages/tsk_p100.spec.sql"
@@"./database/packages/tsk_p110.spec.sql"
@@"./database/views/tsk_lov_users_v.sql"
@@"./database/views/tsk_p510_repositories_v.sql"
@@"./database/views/tsk_p515_endpoints_v.sql"
@@"./database/packages/tsk_nav.spec.sql"
@@"./database/packages/tsk_p105.spec.sql"
@@"./database/views/tsk_p500_commits_v.sql"
@@"./database/packages/tsk_app.spec.sql"
@@"./database/packages/tsk_tapi.spec.sql"
@@"./database/packages/tsk_p110.sql"
@@"./database/views/tsk_available_clients_v.sql"
@@"./database/views/tsk_lov_sequences_v.sql"
@@"./database/packages/tsk_handlers.sql"
@@"./database/packages/tsk_tapi.sql"
@@"./database/views/tsk_available_projects_v.sql"
@@"./database/views/tsk_clients_v.sql"
@@"./database/views/tsk_lov_clients_v.sql"
@@"./database/views/tsk_navigation_clients_v.sql"
@@"./database/views/tsk_sequences_v.sql"
@@"./database/views/tsk_categories_v.sql"
@@"./database/views/tsk_lov_owners_bulk_v.sql"
@@"./database/views/tsk_lov_owners_v.sql"
@@"./database/views/tsk_lov_projects_v.sql"
@@"./database/views/tsk_navigation_projects_v.sql"
@@"./database/views/tsk_statuses_v.sql"
@@"./database/views/tsk_swimlanes_v.sql"
@@"./database/views/tsk_available_boards_v.sql"
@@"./database/views/tsk_lov_repos_v.sql"
@@"./database/views/tsk_lov_boards_bulk_v.sql"
@@"./database/views/tsk_lov_boards_v.sql"
@@"./database/views/tsk_lov_card_autocomplete_v.sql"
@@"./database/views/tsk_navigation_boards_v.sql"
@@"./database/views/tsk_navigation_home_v.sql"
@@"./database/views/tsk_p110_cards_v.sql"
@@"./database/packages/tsk_app.sql"
@@"./database/views/tsk_auth_context_v.sql"
@@"./database/views/tsk_lov_categories_bulk_v.sql"
@@"./database/views/tsk_lov_categories_v.sql"
@@"./database/views/tsk_lov_repo_owners_v.sql"
@@"./database/views/tsk_lov_statuses_all_v.sql"
@@"./database/views/tsk_lov_statuses_bulk_v.sql"
@@"./database/views/tsk_lov_statuses_v.sql"
@@"./database/views/tsk_lov_swimlanes_bulk_v.sql"
@@"./database/views/tsk_lov_swimlanes_v.sql"
@@"./database/views/tsk_boards_v.sql"
@@"./database/views/tsk_navigation_v.sql"
@@"./database/views/tsk_projects_v.sql"
@@"./database/packages/tsk_nav.sql"
@@"./database/views/tsk_p100_cards_v.sql"
@@"./database/views/tsk_p105_checklist_v.sql"
@@"./database/views/tsk_p105_comments_v.sql"
@@"./database/views/tsk_p105_commits_v.sql"
@@"./database/views/tsk_p105_files_v.sql"
@@"./database/views/tsk_p105_tags_v.sql"
@@"./database/packages/tsk_p100.sql"
@@"./database/views/tsk_p105_badges_v.sql"
@@"./database/packages/tsk_p105.sql"

--
-- TRIGGERS
--
@@"./database/triggers/tsk_boards__.sql"
@@"./database/triggers/tsk_card_checklist__.sql"
@@"./database/triggers/tsk_card_comments__.sql"
@@"./database/triggers/tsk_card_commits__.sql"
@@"./database/triggers/tsk_card_files__.sql"
@@"./database/triggers/tsk_cards__.sql"
@@"./database/triggers/tsk_categories__.sql"
@@"./database/triggers/tsk_clients__.sql"
@@"./database/triggers/tsk_commits__.sql"
@@"./database/triggers/tsk_recent__.sql"
@@"./database/triggers/tsk_repo_endpoints__.sql"
@@"./database/triggers/tsk_repos__.sql"
@@"./database/triggers/tsk_sequences__.sql"
@@"./database/triggers/tsk_statuses__.sql"
@@"./database/triggers/tsk_swimlanes__.sql"
@@"./database/triggers/tsk_projects__.sql"

--
-- MVIEWS
--
@@"./patches/50_mviews/50_recompile.sql"

--
-- INDEXES
--
@@"./patches/55_indexes/50_recompile.sql"
--
@@"./database/indexes/pk_tsk_boards.sql"
@@"./database/indexes/pk_tsk_boards_fav.sql"
@@"./database/indexes/pk_tsk_card_checklist.sql"
@@"./database/indexes/pk_tsk_card_comments.sql"
@@"./database/indexes/pk_tsk_card_commits.sql"
@@"./database/indexes/pk_tsk_card_files.sql"
@@"./database/indexes/pk_tsk_cards.sql"
@@"./database/indexes/pk_tsk_categories.sql"
@@"./database/indexes/pk_tsk_clients.sql"
@@"./database/indexes/pk_tsk_commits.sql"
@@"./database/indexes/pk_tsk_projects.sql"
@@"./database/indexes/pk_tsk_recent.sql"
@@"./database/indexes/pk_tsk_repo_endpoint.sql"
@@"./database/indexes/pk_tsk_repos.sql"
@@"./database/indexes/pk_tsk_sequences.sql"
@@"./database/indexes/pk_tsk_status.sql"
@@"./database/indexes/pk_tsk_swimlanes.sql"
@@"./database/indexes/tsk_cards_card_number_uq.sql"
@@"./database/indexes/uq_tsk_boards.sql"
@@"./database/indexes/uq_tsk_card_files.sql"
@@"./database/indexes/uq_tsk_card_files_name.sql"

--
-- DATA
--
@@"./patches/60_data/app_navigation.sql"
--
COMMIT;

--
-- FINALLY
--
@@"./patches/90_finally/98_checks.sql"
@@"./patches/90_finally/96_stats.sql"
@@"./patches/90_finally/93_audit_colums.sql"
@@"./patches/90_finally/94_indexes.sql"
@@"./patches/90_finally/90_recompile.sql"
@@"./patches/90_finally/92_refresh_mvw.sql"

--
-- APEX
--
@@"./database/apex/f710/f710.sql"

