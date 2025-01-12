// ----------------------------------------
// Page: 312 - Copy from Project > Dynamic Action: COPY_SWIMLANES > Action: Execute JavaScript Code > Settings > Code

// fake changes on all rows, submit grid
// close dialog with a message
var grid    = apex.region('SWIMLANES').widget();
var model   = grid.interactiveGrid('getViews', 'grid').model;
//
model.forEach(function(r) {
    try {
        model.setValue(r, 'UPDATED_BY', model.getValue(r, 'UPDATED_BY') + '!');
    }
    catch(err) {
    }
});
//
//grid.interactiveGrid('getActions').invoke('save');
apex.submit('COPY_SWIMLANES');


// ----------------------------------------
// Page: 312 - Copy from Project > Dynamic Action: COPY_STATUSES > Action: Execute JavaScript Code > Settings > Code

// fake changes on all rows, submit grid
// close dialog with a message
var grid    = apex.region('STATUSES').widget();
var model   = grid.interactiveGrid('getViews', 'grid').model;
//
model.forEach(function(r) {
    try {
        model.setValue(r, 'UPDATED_BY', model.getValue(r, 'UPDATED_BY') + '!');
    }
    catch(err) {
    }
});
//
//grid.interactiveGrid('getActions').invoke('save');
apex.submit('COPY_STATUSES');


// ----------------------------------------
// Page: 312 - Copy from Project > Dynamic Action: COPY_CATEGORIES > Action: Execute JavaScript Code > Settings > Code

// fake changes on all rows, submit grid
// close dialog with a message
var grid    = apex.region('CATEGORIES').widget();
var model   = grid.interactiveGrid('getViews', 'grid').model;
//
model.forEach(function(r) {
    try {
        model.setValue(r, 'UPDATED_BY', model.getValue(r, 'UPDATED_BY') + '!');
    }
    catch(err) {
    }
});
//
//grid.interactiveGrid('getActions').invoke('save');
apex.submit('COPY_CATEGORIES');


