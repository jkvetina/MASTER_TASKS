// ----------------------------------------
// Page: 400 - Boards > Dynamic Action: ONE_CHECKBOX_BOARDS > Action: Execute JavaScript Code > Settings > Code

grid_one_checkbox_only('BOARDS', 'IS_DEFAULT');

// ----------------------------------------
// Page: 400 - Boards > Region: Boards [GRID] > Column: APEX$ROW_ACTION > Advanced > Column Initialization JavaScript Function

function (options) {
    //return cell_class(options, '&IS_CURRENT. &BOARD_NAME.');
    return options;
}


