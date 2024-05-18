// ----------------------------------------
// Page: 110 - Bulk Operations > Dynamic Action: CHANGED_CATEGORY > Action: Set Value > Settings > JavaScript Expression

apex.item('P110_SOURCE_CATEGORY').getValue()

// ----------------------------------------
// Page: 110 - Bulk Operations > Dynamic Action: CHANGED_SWIMLANE > Action: Set Value > Settings > JavaScript Expression

apex.item('P110_SOURCE_SWIMLANE').getValue()

// ----------------------------------------
// Page: 110 - Bulk Operations > Dynamic Action: CHANGED_OWNER > Action: Set Value > Settings > JavaScript Expression

apex.item('P110_SOURCE_OWNER').getValue()

// ----------------------------------------
// Page: 110 - Bulk Operations > Dynamic Action: PROCESS_ALL_ROWS > Action: Execute JavaScript Code > Settings > Code

process_grid_all_rows('AFFECTED_CARDS', 'SELECTED_ROW', this.triggeringElement.id);

// ----------------------------------------
// Page: 110 - Bulk Operations > Dynamic Action: PROCESS_SELECTED_ROWS > Action: Execute JavaScript Code > Settings > Code

process_grid_selected_rows('AFFECTED_CARDS', 'SELECTED_ROW', this.triggeringElement.id);

// ----------------------------------------
// Page: 110 - Bulk Operations > Dynamic Action: CHANGED_STATUS > Action: Set Value > Settings > JavaScript Expression

apex.item('P110_SOURCE_STATUS').getValue()

