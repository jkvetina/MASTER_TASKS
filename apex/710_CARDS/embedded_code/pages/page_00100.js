// ----------------------------------------
// Page: 100 - &APP_NAME. > Dynamic Action: DIALOG_CLOSED > When > JavaScript Expression

window

// ----------------------------------------
// Page: 100 - &APP_NAME. > Dynamic Action: AFTER_GRID_REFRESH > Action: Execute JavaScript Code > Settings > Code

// this also works
$('#BOARD').on('apexafterrefresh', function() {
});

// ----------------------------------------
// Page: 100 - &APP_NAME. > Dynamic Action: AFTER_GRID_REFRESH > Action: Execute JavaScript Code > Settings > Code

show_success('Board refreshed');

// ----------------------------------------
// Page: 100 - &APP_NAME. > Dynamic Action: INIT_GRID > Action: Execute JavaScript Code > Settings > Code

init_grid();


// ----------------------------------------
// Page: 100 - &APP_NAME. > Dynamic Action: DIALOG_CLOSED > Action: Execute JavaScript Code > Settings > Code

location.reload();  // dont work properly
//window.location = apex.item('P100_CARDS_LINK').getValue();


// ----------------------------------------
// Page: 100 - &APP_NAME. > Dynamic Action: OPEN_DETAIL > Action: Execute JavaScript Code > Settings > Code

window.location.href = apex.item('P100_CARD_LINK').getValue();


// ----------------------------------------
// Page: 100 - &APP_NAME. > Dynamic Action: REFRESH_GRID_ON_CARD_MOVE > When > JavaScript Expression

document

