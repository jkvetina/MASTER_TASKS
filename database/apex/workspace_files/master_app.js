//
// HANDLE AJAX PROCESS MESSAGES
//
const show_success = function(message) {
    apex.message.showPageSuccess(message);
};
//
const show_warning = function(message) {
    apex.message.clearErrors();
    apex.message.showErrors([{
        type:       apex.message.TYPE.ERROR,    // sadly no warning supported
        location:   ['page'],
        message:    'WARNING! ' + message,      // so we will fake it
        unsafe:     false
    }]);
};
//
const show_error = function(message) {
    apex.message.clearErrors();
    apex.message.showErrors([{
        type:       apex.message.TYPE.ERROR,
        location:   ['page'],
        message:    message,
        unsafe:     false
    }]);
};
//
const show_message = function(data) {           // expecting JSON objects, ideally from core.set_json_message
    if (data.message) {
        if (data.status == 'SUCCESS') {
            apex.message.showPageSuccess(data.message);
        }
        else {
            apex.message.showErrors([{
                type:       data.status,
                location:   ['page'],
                message:    data.message,
                unsafe:     false
            }]);
        }
    }
};



//
// WAIT FOR ELEMENT TO EXIST
//
const wait_for_element = function(search, start, fn, disconnect) {
    var ob  = new MutationObserver(function(mutations) {
        if ($(search).length) {
            fn(search, start);
            if (disconnect) {
                observer.disconnect();  // keep observing
            }
        }
    });
    //
    ob.observe(document.getElementById(start), {
        childList: true,
        subtree: true
    });
};



//
// WAIT FOR SPECIFIC AMOUNT OF TIME
//
function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}



//
// COPY TO CLIPBOARD
//
const copy_to_clipboard = function (text) {
    var dummy = document.createElement('textarea');
    document.body.appendChild(dummy);
    dummy.value = text;
    dummy.select();
    document.execCommand('copy');
    document.body.removeChild(dummy);
}



//
// COPY GRID CELL - ATTACH ONLY TO GRIDS AND TO READ ONLY CELLS
//
/*
const attach_copy_to_grid = function (el) {
    console.log('ADDING...', el);
    $(el).one('copy', (event) => {
        console.log('ATTACHED');
        event.clipboardData.setData('text/plain', $(document.activeElement)[0].innerText || window.getSelection());
        event.preventDefault();
    });
};
//
wait_for_element('.a-GV-cell', 'main', attach_copy_to_grid);
*/



//
// CREATE COLORFUL IG/IR CELLS
//
const color_cell = function (options, value, title, color_bg, color_text) {
    if (value && value.length && ((color_bg && color_bg.length) || (color_text && color_text.length))) {
        options.defaultGridColumnOptions = {
            cellTemplate: '<div style="background: ' + color_bg + '; color: ' + color_text + ';" title="' + title + '">' + value + '</div>'
        };
    }
    else {
        options.defaultGridColumnOptions = {
            cellTemplate: '<span title="' + title + '">' + value + '</span>'
        };
    }
    return options;
}



//
// WHEN PAGE LOADS
//
var ping_active = true;
var ping_loop;
var last_scheduler;
//
var init_page = function() {
    // autohide success messages
    // this actually dont work together with the following setThemeHooks
    apex.theme42.util.configAPEXMsgs({
        autoDismiss : true,
        duration    : 2300
    });

    // catch message event
    apex.message.setThemeHooks({
        beforeShow: function(pMsgType, pElement$) {
            if (pMsgType === apex.message.TYPE.ERROR) {
                var message = pElement$.find('ul.a-Notification-list li').text();
                console.log('MESSAGE:', pMsgType, pElement$, message);

                // switch error to warning
                if (message.includes('WARNING!')) {
                    message = message.replace('WARNING!', '').trim();
                    pElement$.find('.t-Alert--warning').addClass('t-Alert--yellow');
                    pElement$.find('.a-Notification-item').first().html(message);
                }

                // stop pinging on session timeout error
                if (message.toUpperCase().includes('YOUR SESSION HAS ENDED')) {
                    ping_active = false;
                    for (var i = 0 ; i <= ping_loop; i++) {
                        clearTimeout(i); 
                    }
                    // also redirect to login page
                    window.location.href = apex.item('P0_SESSION_TIMEOUT_URL').getValue();
                }
            }

            // autohide success messages
            // this message can be from AJAX call (AJAX_PING process) and then it wont be autoclosed
            if (pMsgType === apex.message.TYPE.SUCCESS) {
                clearTimeout(last_scheduler);
                last_scheduler = setTimeout(() => {
                    apex.message.hidePageSuccess();
                }, 2300);
            }
        },
        beforeHide: function(pMsgType, pElement$) {
        }
    });

    //
    // PING FOR LOGGED USERS
    //
    var ping_interval = parseInt(apex.item('P0_AJAX_PING_INTERVAL').getValue());
    var ping_fn = function() {
        if (!ping_active) {
            return;
        }
        //
        console.log('CALL AJAX_PING');
        apex.server.process (
            'AJAX_PING',
            {
                //x01: 1,
                //x02: 2,
                //x03: 3,
                //p_arg_names   : [''],     // set items?
                //p_arg_values  : [''],
            },  // params
            {
                async       : true,
                dataType    : 'json',
                success     : function(data) {
                    //console.log('PING RECEIVED', ping_loop, data);
                    show_message(data);
                }
            }
        );
        //
        if (ping_active && ping_interval > 0) {
            ping_loop = setTimeout(function() { ping_fn(); }, ping_interval * 1000);
        }
    };
    if (ping_active && ping_interval > 0 && apex.item('P0_AJAX_PING_INTERVAL').node) {
        ping_loop = ping_fn();
    }

    //
    // ADJUST GRIDS
    //
    fix_grid_toolbars();
    fix_grid_save_button();
};

// fix badges on buttons
$('button > .t-Button-label').each(function(k, id) {
    $(id).html($(id).html().replace(/\[([^\]]+)\]/, '<div class="BADGE">$1</div>'));
});

// when page is loaded
$(function() {
});

// when all APEX components are loaded
apex.jQuery(window).on('theme42ready', function() {
    init_page();
});





//
// COMMON TOOLBAR FOR ALL GRIDS
//
var fix_grid_toolbars = function () {
    $('.a-IG').each(function() {
        var $parent = $(this).parent();
        var id      = $parent.attr('id');
        //
        if (!$parent.hasClass('ORIGINAL')) {
            //console.log('GRID MODIFIED', id);
            fix_grid_toolbar(id);
        }
    })
};
//
var fix_grid_toolbar = function (region_id) {
    console.group('FIX_GRID_TOOLBAR', region_id);
    //
    var $region     = $('#' + region_id);
    var widget      = apex.region(region_id).widget();
    var actions     = widget.interactiveGrid('getActions');
    var toolbar     = widget.interactiveGrid('getToolbar');
    var config      = $.apex.interactiveGrid.copyDefaultToolbar();
    var action1     = config.toolbarFind('actions1');
    var action2     = config.toolbarFind('actions2');
    var action3     = config.toolbarFind('actions3');
    var action4     = config.toolbarFind('actions4');
    //
    //console.log('TOOLBAR DATA - ORIGINAL', config_bak.data);
    //console.log('ACTIONS', widget.interactiveGrid('getActions').list());

    // manipulate buttons
    // https://docs.oracle.com/en/database/oracle/application-express/20.1/aexjs/interactiveGrid.html#actions-section
    //
    // grid actions
    // widget.interactiveGrid('getActions').list()
    //console.log('ACTIONS', widget.interactiveGrid('getActions').list());
    //
    // row actions
    // widget.interactiveGrid('getViews').grid.rowActionMenu$.menu('option')
    //

    // hide some buttons
    actions.hide('reset-report');
    actions.show('change-rows-per-page');

    // modify save button
    for (var i = 0; i < action2.controls.length; i++) {
        var button = action2.controls[i];
        if (button.action == 'save') {
            button.hot          = false;
            button.label        = 'Save Changes';
            break;
        }
    }

    // modify add row button as a plus sign without text
    for (var i = 0; i < action3.controls.length; i++) {
        var button = action3.controls[i];
        if (button.action == 'selection-add-row') {
            button.icon         = 'fa fa-plus';
            button.iconOnly     = true;
            button.label        = ' ';
            break;
        }
    }

    // add action to save all rows in grid
    if ($region.hasClass('SAVE_ALL')) {
        actions.add({
            name    : 'SAVE_ALL',
            action  : function(event, element) {
                var region_id   = event.delegateTarget.id.replace('_ig', '');
                var grid        = apex.region(region_id).widget();
                var model       = grid.interactiveGrid('getViews', 'grid').model;
                //
                console.log('CALL SAVE_ALL', region_id, grid, model);
                //
                model.forEach(function(r) {
                    try {
                        var fake_change = model.getValue(r, 'MARK_AS_CHANGED');     // grid column name
                        if (fake_change == '') {                                    // expected value (null)
                            model.setValue(r, 'MARK_AS_CHANGED', 'Y ');             // different value to force change
                        }
                    }
                    catch(err) {  // deleted rows cant be changed
                    }
                });
                grid.interactiveGrid('getActions').invoke('save');
                grid.interactiveGrid('getCurrentView').model.fetch();
            }
        });
        //
        action2.controls.push({
            type        : 'BUTTON',
            label       : 'Save All Rows',
            id          : 'save_all_rows',
            icon        : '',
            action      : 'SAVE_ALL'
        });
    }

    // add action to save all selected and changed rows
    if ($region.hasClass('SAVE_SELECTED')) {
        actions.add({
            name    : 'SAVE_SELECTED',
            action  : function(event, element) {
                var region_id   = event.delegateTarget.id.replace('_ig', '');
                var grid        = apex.region(region_id).widget();
                var model       = grid.interactiveGrid('getViews', 'grid').model;
                var gridview    = grid.interactiveGrid('getViews').grid;
                var selected    = grid.interactiveGrid('getViews').grid.getSelectedRecords();
                var id;
                var changed = [];
                //
                console.log('CALL SAVE_SELECTED', region_id, grid, model);
                //
                for (var i = 0; i < selected.length; i++ ) {
                    id = gridview.model.getRecordId(selected[i]);
                    changed.push(id);
                };
                //
                model.forEach(function(r) {
                    for (var i = 0; i < changed.length; i++ ) {
                        if (changed[i] == gridview.model.getRecordId(r)) {
                            try {
                                var fake_change = model.getValue(r, 'MARK_AS_CHANGED');     // grid column name
                                if (fake_change == '') {                                    // expected value (null)
                                    model.setValue(r, 'MARK_AS_CHANGED', 'Y ');             // different value to force change
                                }
                            }
                            catch(err) {  // deleted rows cant be changed
                            }
                        }
                    }
                });
                //
                grid.interactiveGrid('getActions').invoke('save');

                // refresh grid after save
                //grid.interactiveGrid('getViews', 'grid').model.clearChanges();
                //grid.interactiveGrid('getActions').invoke('refresh');
                grid.interactiveGrid('getCurrentView').model.fetch();
            }
        });
        //
        action2.controls.push({
            type        : 'BUTTON',
            label       : 'Save Selected',
            id          : 'save_all_rows',
            icon        : '',
            action      : 'SAVE_SELECTED',
        });
    }

    // return back the row selectors
    /*
    action2.controls.unshift({
        type    : 'SELECT',
        action  : 'change-rows-per-page'
    });*/

    // show refresh button before save button
    action4.controls.push({
        type            : 'BUTTON',
        action          : 'refresh',
        label           : 'Refresh',
        icon            : '',
        iconBeforeLabel : true
    });

    // only for developers
    if ($('#apexDevToolbar.a-DevToolbar')) {
        // add a filter button after the actions menu
        action4.controls.push({
            type        : 'BUTTON',
            action      : 'save-report',
            label       : 'Save as Default',
            icon        : ''  // no icon
        });
    }

    // keep selected rows
    config.defaultGridViewOptions = {
        persistSelection: true
    };

    // update toolbar
    //actions.set('edit', true);
    toolbar.toolbar('option', 'data', config);
    toolbar.toolbar('refresh');
    console.groupEnd();
};



//
// FIX GRID SAVE BUTTON - look for css change on Edit button and apply it to Save button
//
var fix_grid_save_button = function () {
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            // when Edit button is changed to active, then change Save button to hot
            var $target = $(mutation.target);
            if ($target.hasClass('is-active')) {
                $target.parent().parent().find('button.a-Toolbar-item[data-action="save"]').addClass('is-active a-Button--hot');
                //observer.disconnect();  // remove observer when fired
            }
        });
    });

    // find Edit buttons on grids
    $.each($('.a-Toolbar-button[name="edit"]'), function(i, el) {
        $el = $(el);
        observer.observe($el[0], {
            attributes: true
        });
    });
};



//
// FIX GRID FOLDING - fold (hide) requested group (Control Break)
//
var fold_grid_group = function(grid_id, group_name, group_value) {
    (function loop(i) {
        setTimeout(function() {
            $('#' + grid_id + ' table tbody tr button.a-Button.js-toggleBreak').each(function() {
                if (i > 0) {
                    $x = $(this);
                    var $b = $x.parent().find('.a-GV-controlBreakLabel');
                    var label = $b.find('.a-GV-breakLabel').text();
                    var text = $b.find('.a-GV-breakValue').text();
                    if (label.startsWith(group_name) && text.trim() == group_value) {
                        $x.click();
                        $x.blur();
                        $(window).scrollTop(0);
                        i = 0;
                        return;
                    }
                }
            });
            if (--i) loop(i);
        }, 200)
    })(10);
};

