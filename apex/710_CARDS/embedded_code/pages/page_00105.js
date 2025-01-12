// ----------------------------------------
// Page: 105 - Card Detail > JavaScript > Function and Global Variable Declaration

const submit_checklist = function (button_id) {
    renumber_grid_rows('CHECKLIST', 'NEW_ORDER');
    apex.submit(button_id);
};



const delete_comment = function (card_id, comment_id) {
    apex.server.process('AJAX_DELETE_COMMENT',
        {
            x01: card_id,
            x02: comment_id
        },
        {
            dataType: 'text',
            success: function(pData) {
                console.log('RESULT', pData);
                if (pData.indexOf('sqlerrm') >= 0) {
                    apex.message.showErrors([{
                        type        : 'error',
                        location    : ['page', 'inline'],
                        pageItem    : '',
                        message     : pData.split('sqlerrm:')[1],
                        unsafe      : false
                    }]);
                }
                else {
                    apex.message.showPageSuccess(pData);
                }
                //
                apex.region('COMMENTS').refresh();
            }
        }
    );
};



// ----------------------------------------
// Page: 105 - Card Detail > Region: Checklist [GRID] > Column: CHECKLIST_ITEM > Advanced > Column Initialization JavaScript Function

function(config) {
  config.defaultGridColumnOptions = {
    cellCssClassesColumn: 'CSS_CLASS'
  };
  return config;
}

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: UPDATE_CARD_AND_CLOSE > Action: Execute JavaScript Code > Settings > Code

submit_checklist(this.triggeringElement.id);

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: CHANGED_CATEGORY > Action: Execute JavaScript Code > Settings > Code

// change styles
var color_map   = JSON.parse(apex.item('P105_CATEGORY_JSON').getValue())[0];
var category_id = apex.item('P105_CATEGORY_ID').getValue();
var color       = color_map[category_id];
//
if (color && color.length > 0) {
    $('select#P105_CATEGORY_ID').css('border-left', '8px solid ' + color);
    $('label#P105_CATEGORY_ID_LABEL').css('padding-left', '0.95rem');
}
else {
    $('select#P105_CATEGORY_ID').css('border-left', '1px solid var(--a-field-input-state-border-color,var(--a-field-input-border-color))');
    $('label#P105_CATEGORY_ID_LABEL').css('padding-left', '0.5rem');
}


// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: UPDATE_AND_REFRESH > Action: Execute JavaScript Code > Settings > Code

submit_checklist(this.triggeringElement.id);

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: CREATE_ANOTHER > Action: Execute JavaScript Code > Settings > Code

submit_checklist(this.triggeringElement.id);

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: CREATE_CARD > Action: Execute JavaScript Code > Settings > Code

submit_checklist(this.triggeringElement.id);

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: CREATE_CARD_AND_CLOSE > Action: Execute JavaScript Code > Settings > Code

submit_checklist(this.triggeringElement.id);

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: RENUMBER_CHECKLIST > Action: Execute JavaScript Code > Settings > Code

console.log('NEW_ROW_INIT');

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: STACKED_MODAL_CLOSED > Action: REDIRECT_TO_NEW_PAGE > Settings > Code

show_success('Cards merged.');
apex.navigation.redirect(apex.item('P105_MERGE_CARD').getValue());


// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: STACKED_MODAL_CLOSED > Action: GET_MODAL_PAGE_NUMBER > Settings > Code

// detect which page closed
console.log('MODAL_CLOSED', this.data.dialogPageId);
//console.log('MORE_INFO', $(this.browserEvent.target).parent(), $(this.browserEvent.target).attr('class'));  // we can check CSS class for example


// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: DELETE_FILE > Action: Execute JavaScript Code > Settings > Code

show_message('File deleted');

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: DELETE_FILE > Action: Set Value > Settings > JavaScript Expression

this.data.file_id

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: DELETE_COMMENT > Action: Execute JavaScript Code > Settings > Code

show_message(apex.item('P105_COMMENT_MESSAGE').getValue());

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: DELETE_COMMENT > Action: Set Value > Settings > JavaScript Expression

this.data.comment_id

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: DELETE_COMMENT > Action: Set Value > Settings > JavaScript Expression

this.data.card_id

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: REQUESTED_STATUS > Action: Execute JavaScript Code > Settings > Code

apex.item('P105_STATUS_ID').setValue(apex.item('P105_STATUS_REQUESTED').getValue());

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: STACKED_MODAL_CLOSED > When > JavaScript Expression

window

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: DELETE_FILE > When > JavaScript Expression

document

// ----------------------------------------
// Page: 105 - Card Detail > Dynamic Action: DELETE_COMMENT > When > JavaScript Expression

document

// ----------------------------------------
// Page: 105 - Card Detail > JavaScript > Execute when Page Loads

// CATCH ENTER KEY PRESS
const region_id = 'CHECKLIST';
$('#' + region_id + ' .a-GV').on('keydown', 'input', function(event) {
    if (event.which === 13) {
        // add new line below current line
        var $widget = apex.region(region_id).widget();
        $widget.interactiveGrid('getActions').invoke('selection-add-row');
        event.stopPropagation();
    }
});

// MAKE THE GRID EDITABLE (WITH A DELAY)
$(function() {
    var static_id = 'CHECKLIST';
    (function loop(i) {
        setTimeout(function() {
            try {
                var region  = apex.region(static_id);
                var grid    = region.widget();
                var model   = grid.interactiveGrid('getViews', 'grid').model;
                var current = grid.interactiveGrid('getViews').grid.getSelectedRecords()[0];
                //
                region.call('getActions').set('edit', true);
                if (current !== undefined) {
                    return;
                }
            }
            catch(err) {
            }
            if (--i) loop(i);
        }, 100)
    })(20);
});


