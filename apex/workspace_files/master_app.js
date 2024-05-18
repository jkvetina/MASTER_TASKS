const is_modal = function() {
    return apex.env.APP_PAGE_ID !== apex.util.getTopApex().env.APP_PAGE_ID;
    // or we could check the classes: !$('body').hasClass('t-Dialog-page')
};



//
// WHEN PAGE LOADS
//
var ping_active = !is_modal();
var ping_loop;
var last_scheduler;
//
const init_page_asap = function() {
    const autohide_after = 2300;

    // autohide success messages
    // this actually dont work together with the following setThemeHooks
    apex.theme42.util.configAPEXMsgs({
        autoDismiss : true,
        duration    : autohide_after
    });

    // catch message event
    apex.message.setThemeHooks({
        beforeShow: function(pMsgType, pElement$) {
            // error messages
            if (pMsgType === apex.message.TYPE.ERROR) {
                var msg = get_message(pElement$.find('ul.a-Notification-list li').html());
                console.log('MESSAGE.ERROR:', msg);

                // switch error to warning
                if (msg.status == 'WARNING') {
                    pElement$.find('.t-Alert--warning').addClass('t-Alert--yellow');
                }

                // change message
                pElement$.find('.a-Notification-item').first().html(msg.message);
                //
                // @TODO: need fix for multiple messages
                //

                // stop pinging on session timeout error
                if (msg.message.toUpperCase().includes('YOUR SESSION HAS ENDED')) {
                    ping_active = false;
                    for (var i = 0 ; i <= ping_loop; i++) {
                        clearTimeout(i); 
                    }
                    redirect_to_login();
                }
            }

            // success messages
            if (pMsgType === apex.message.TYPE.SUCCESS) {
                var msg = get_message($('#APEX_SUCCESS_MESSAGE h2.t-Alert-title').html());
                console.log('MESSAGE.SUCCESS:', msg);

                // change message
                $('#APEX_SUCCESS_MESSAGE h2.t-Alert-title').text(msg.message);

                // auto hide success message
                // this message can be from AJAX call (AJAX_PING process) and then it wont be autoclosed
                clearTimeout(last_scheduler);
                last_scheduler = setTimeout(() => {
                    apex.message.hidePageSuccess();
                }, autohide_after);
            }

            // execute action if requested
            if (!!msg.action) {
                console.log('TRIGGER_ACTION', msg.action);
                $.event.trigger(msg.action);    // @TODO: pass more arguments
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
                dataType    : 'text',
                success     : function(payload) {
                    if (payload.trim().length > 0) {
                        try {
                            const obj = JSON.parse(payload);
                            console.log('PING RECEIVED, JSON', obj);
                            show_message(obj);
                        }
                        catch(err) {
                            console.log('PING RECEIVED, TEXT', payload, err);
                            show_message(payload);
                        }
                    }
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
};

const init_page = function() {
    //
    // ADJUST GRIDS
    //
    $('.a-IG').each(function() {
        var $parent     = $(this).parent();
        var static_id   = $parent.attr('id');
        //
        if (!$parent.hasClass('ORIGINAL')) {
            $('#' + static_id).on('interactivegridviewchange', function(event, data) {
                //delay(100).then(() => );
                alert('GRID CREATED ' + static_id);
            });
            //
            fix_grid_toolbar(static_id);
        }
    });
    //
    //fix_grid_save_button();

    // fix badges on buttons
    $('button > .t-Button-label').each(function(k, id) {
        $(id).html($(id).html().replace(/\[([^\]]+)\]/, '<div class="BADGE">$1</div>'));
    });

    //
    // INIT ACTION MENUS
    //
    $('body').on('click', 'button.ACTION_MENU', show_action_menu);
    $('html').click(function() {
        $('div.ACTION_MENU').hide();
    });
    $('div.ACTION_MENU a').click(function(e) {
        var f = $(this);
        console.log('MENU CLICK', f, e);
    });

    // catch IG refresh, thanks to @KarelEkema
    $(document).on('ajaxComplete', function(jQueryEvent, data, settings) {
        var region_id, static_id;
        try {
            region_id = data.responseJSON.regions[0].id;
            static_id = $('.t-IRR-region.lto' + region_id + '_0').attr('id');
        }
        catch(err) {
        }
        if (data.status == 200 && static_id !== undefined) {
            delay(100).then(() => fix_grid_default(static_id));
        }
    });

    // delayed init
    delay(300).then(() => init_page_delayed());
};
//
const init_page_delayed = function() {
    //
    // ADJUST GRIDS
    //
    $('.a-IG').each(function() {
        var $parent     = $(this).parent();
        var static_id   = $parent.attr('id');
        //
        if (!$parent.hasClass('ORIGINAL')) {
            fix_grid_default(static_id);
        }
    });
};



// when page is loaded
$(function() {
    init_page_asap();
    reset_tabs();

    /*
    $.widget('apex.interactiveGrid', $.apex.interactiveGrid, {
        refresh: function () {
            alert('Hello, I should refresh now...');
            this._super();
        }
    });
    */
});

// when all APEX components are loaded
apex.jQuery(window).on('theme42ready', function() {
    init_page();
});



//
// CHECK SESSION - redirect to login page when session expire
//
const redirect_to_login = function() {
    if (apex.env.APP_ID == 800 && apex.env.APP_PAGE_ID == 9999 && (
        apex.env.APP_SESSION == 0   // dont work for 0
        || window.location.search.startsWith('?p=800:9999:0:')
        || window.location.search.startsWith('?session=0'))) {
        return;  // already on login page
    }
    if (!!apex.item('P0_SESSION_TIMEOUT_URL').getValue()) {
        window.location.href = apex.item('P0_SESSION_TIMEOUT_URL').getValue();
    }
    else {
        //apex.navigation.redirect("&LOGOUT_URL.");     // not available here
        apex.navigation.redirect('/ords/f?p=800:9999:0::::P9999_ERROR:SESSION_TIMEOUT');
    }
};
//
const check_session = function () {
    $(document).on('dialogopen', function(event) {  
        if ($('button:contains("Sign In Again")').length > 0) {
            event.preventDefault();
            event.stopPropagation();
            //
            //redirect_to_login();
            return false;
        }
    });
};



//
// HANDLE AJAX PROCESS MESSAGES
//
const show_success = function(msg) {
    apex.message.showPageSuccess(JSON.stringify(get_message(msg, 'SUCCESS')));
};
//
const show_warning = function(msg) {
    apex.message.clearErrors();
    apex.message.showErrors([{
        type:       apex.message.TYPE.ERROR,    // sadly no warning supported
        location:   ['page'],
        message:    JSON.stringify(get_message(msg, 'WARNING')),
        unsafe:     false
    }]);
};
//
const show_error = function(msg) {
    apex.message.clearErrors();
    apex.message.showErrors([{
        type:       apex.message.TYPE.ERROR,
        location:   ['page'],
        message:    JSON.stringify(get_message(msg, 'ERROR')),
        unsafe:     false
    }]);
};
//
const show_message = function(msg) {           // expecting JSON objects, ideally from core.set_json_message
    if (!!msg.message) {
        if (msg.status == 'SUCCESS') {
            show_success(msg);
        }
        else if (msg.status == 'WARNING') {
            show_warning(msg);
        }
        else {
            show_error(msg);
        }
    }
};
//
const get_message = function(payload, status, action) {
    var msg = {
        'message'   : payload,
        'status'    : status,
        'action'    : action
    };
    if (typeof payload == 'object') {
        msg.message = (!!payload.message ? payload.message : msg.message);
        msg.status  = (!!payload.status  ? payload.status  : msg.status);
        msg.action  = (!!payload.action  ? payload.action  : msg.action);
    }
    else if (typeof payload == 'string' && payload.substring(0, 1) === '{' && payload.trim().slice(-1) === '}') {
        try {
            const obj = JSON.parse(payload);
            //
            msg.message = (!!obj.message ? obj.message : msg.message);
            msg.status  = (!!obj.status  ? obj.status  : msg.status);
            msg.action  = (!!obj.action  ? obj.action  : msg.action);
        }
        catch(err) {
            console.error('JSON_PARSE_FAILED', payload, err);
        }
    }
    return msg;
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
const delay = function (time) {
    return new Promise(resolve => setTimeout(resolve, time));
};



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
};



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
};
//
const cell_class = function (options, value, title) {
    options.defaultGridColumnOptions = {
        cellCssClassesColumn: 'CSS_CLASS'
    };
    return options;
};



//
// COMMON TOOLBAR FOR ALL GRIDS
//
const fix_grid_toolbar = function (region_id) {
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
        persistSelection: true,
        rowHeader: "sequence",      // not working
        singleRowView: false
    };

    // turn off single row view - NOT WORKING
    //var features = apex.util.getNestedObject( config, 'views.grid.features');
    //features.singleRowView = false;
    //config.views.grid.features.rowHeader = 'sequence';
    //config.views.grid.features.singleRowView = false;
    //config.defaultGridViewOptions.rowHeader = "sequence";
    //config.defaultGridViewOptions.singleRowView = false;
    

    //actions.set('edit', true);    // not working
    //config.editable = true;

    // update toolbar
    toolbar.toolbar('option', 'data', config);
    toolbar.toolbar('refresh');
    console.groupEnd();
};



//
// FIX GRID SAVE BUTTON - look for css change on Edit button and apply it to Save button
// UNUSED, CATCH IT VIA MODEL.SUBSCRIBE
//
const fix_grid_save_button = function () {
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
// FIX GRID CHECKBOX CLICK
// ACTIVATE EDIT MODE, SELECT CURRENT ROW, PROCEED WITH GRID_ONE FUNCTION
//
const fix_grid_checkbox = function(grid_id) {
    console.log('FIXING CHECKBOX', grid_id);
    //    
    $('#' + grid_id + ' div.a-IG div.a-IG-body div.a-IG-contentContainer div.a-GV div.a-GV-bdy table.a-GV-table.a-GV-table--checkbox tbody td span.u-checkbox').on('click', function() {
        var grid = apex.region(grid_id);
        if (!grid.call('getActions').get('edit')) {
            grid.call('getActions').set('edit', true);
            $(this).closest('th.a-GV-cell.a-GV-selHeader').click();
        }
    });
};



//
// FIX GRID AFTER REFRESH (ON THE SCREEN, NOT JUST THE MODEL REFRESH)
// MARK CURRENT ROW WITH ARROW, FIX IS_DEFAULT COLUMNS (ONE CHECKBOX ONLY FOR ALL ROWS)...
//
const fix_grid_default = function(static_id) {
    console.group('GRID_MODIFIED + DELAYED', static_id, grid, model);
    //
    var grid        = apex.region(static_id).widget();
    var model       = grid.interactiveGrid('getViews', 'grid').model;
    var gridview    = grid.interactiveGrid('getViews').grid;
    //
    console.log('GRID', grid);
    console.log('MODEL', model);
    console.log('VIEW', gridview);

    // find current row selector
    var current_id = apex.item('P#_CURRENT_'.replace('#', apex.env.APP_PAGE_ID) + static_id).getValue();
    if (current_id) {
        current_id = current_id.replaceAll('&quot;', '').replace('[', '').replace(']', '');  // for composite keys
        $('#' + static_id + ' .a-GV-bdy tr').each(function () {
            if ('' + $(this).data('id') === current_id) {
                var current_row = $(this).find('.a-GV-cell.u-tS.has-button > button > span');
                current_row.removeClass('a-Icon').addClass('fa fa-arrow-circle-right');
                console.log('CURRENT ROW FIXED', current_row);
            }
        });
    }

    //
    // CATCH GRID COLUMN CHANGE
    //
    var viewId = model.subscribe({
        onChange: function(changeType, change) {
            var grid        = apex.region(static_id).widget();
            var model       = grid.interactiveGrid('getViews', 'grid').model;
            var gridview    = grid.interactiveGrid('getViews').grid;
            var columns     = {};
            //
            gridview.getColumns().forEach(function(row) {
                columns[row.property] = row.index;
            });
            //
            console.group('GRID_CHANGED', static_id, 'TYPE:', changeType, change);
            //console.log('CHANGE', changeType, change);
            //console.log('MODEL', model);
            //console.log('VIEW', gridview);
            //console.log('COLUMNS:', columns, gridview.getColumns());

            // on any change make Save button hot
            $('#' + static_id).find('button.a-Toolbar-item[data-action="save"]').addClass('is-active a-Button--hot');

            //
            // MAKE SURE WE CAN SELECT ONLY ONE CHECKBOX IN A COLUMN THROUGH ALL ROWS
            // GRID MUST BE IN EDIT MODE TO MAKE THIS WORK
            //
            if ((changeType == 'set' || changeType == 'insert') && !!gridview.modelColumns['IS_DEFAULT']) {
                console.log('CHANGED COLUMN', 'ID=' + change.recordId, 'COL=' + change.field, 'OLD=' + change.oldValue, 'NEW=' + change.record[columns[change.field]], 'DATA:', change.record);
                //
                var new_default = (change.field == 'IS_DEFAULT' && change.oldValue === '' && change.record[columns[change.field]] == 'Y');
                if (new_default) {
                    model.forEach(function(r, idx, id) {
                        // new default selected, remove old values
                        if (id !== change.recordId) {
                            if (model.getValue(r, 'IS_DEFAULT') == 'Y') {
                                model.setValue(r, 'IS_DEFAULT', '');
                            }
                        }
                    });

                    console.warn('CHANGE MODEL', model);
                    // refresh grid after model change
                    //grid.interactiveGrid('getActions').invoke('save');
                    //grid.interactiveGrid('getViews', 'grid').model.clearChanges();
                    //grid.interactiveGrid('getActions').invoke('refresh');
                    //grid.interactiveGrid('getCurrentView').model.fetch();
                    //model.fetchRecords(model._data);
                    //gridview.view$.grid('refresh');
                    //alert('REFRESHED');
                }
            }
            console.groupEnd();
        }
    });
    //
    fix_grid_checkbox(static_id);
    //
    console.groupEnd();
};



//
// FIX GRID FOLDING - fold (hide) requested group (Control Break)
//
const fold_grid_group = function(grid_id, group_name, group_value) {
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



//
// PROCESS ALL ROWS FROM GRID
//
const process_grid_all_rows = function (static_id, fake_column_name, action_name) {
    var grid    = apex.region(static_id).widget();
    var model   = grid.interactiveGrid('getViews', 'grid').model;
    //
    model.forEach(function(r, i) {
        try {
            model.setValue(r, fake_column_name, model.getValue(r, fake_column_name) + '!');
        }
        catch(err) {
        }
    });
    //grid.interactiveGrid('getActions').invoke('save');
    apex.submit(action_name);
};



//
// PROCESS SELECTED ROWS FROM GRID
//
const process_grid_selected_rows = function (static_id, fake_column_name, action_name) {
    var grid        = apex.region(static_id).widget();
    var model       = grid.interactiveGrid('getViews', 'grid').model;
    var gridview    = grid.interactiveGrid('getViews').grid;
    var selected    = grid.interactiveGrid('getViews').grid.getSelectedRecords();
    var changed     = [];
    //
    for (var i = 0; i < selected.length; i++ ) {
        var id = gridview.model.getRecordId(selected[i]);
        changed.push(id);
    };
    //
    model.forEach(function(r) {
        try {
            for (var i = 0; i < changed.length; i++ ) {
                if (changed[i] == gridview.model.getRecordId(r)) {
                    try {
                        model.setValue(r, fake_column_name, 'Y');
                    }
                    catch(err) {
                    }
                }
            }
        }
        catch(err) {
        }
    });
    //grid.interactiveGrid('getActions').invoke('save');
    apex.submit(action_name);
};



//
// RENUMBER ROWS IN GRID SO WE ENSURE THE ORDER OF ROWS
//
const renumber_grid_rows = function (static_id, column_name) {
    var grid    = apex.region(static_id).widget();
    var model   = grid.interactiveGrid('getViews', 'grid').model;
    //
    model.forEach(function(r, i) {
        var res;
        try {
            res = model.setValue(r, column_name, '#' + i);
        }
        catch(err) {
            console.error('ERROR:', i, r, res, err);
        }
    });
};



//
// MAKE SURE WE CAN SELECT ONLY ONE CHECKBOX IN A COLUMN THROUGH ALL ROWS
// GRID MUST BE IN EDIT MODE TO MAKE THIS WORK
//
const grid_one_checkbox_only = function (static_id, column_name) {
    var grid        = apex.region(static_id).widget();
    var model       = grid.interactiveGrid('getViews', 'grid').model;
    var gridview    = grid.interactiveGrid('getViews').grid;
    var selected    = grid.interactiveGrid('getViews').grid.getSelectedRecords();
    var selected_id;
    if (selected && selected.length > 0) {
        selected_id = gridview.model.getRecordId(selected[0]);
    }
    //
    model.forEach(function(r, idx, id) {
        try {
            if (id !== selected_id && model.getValue(r, column_name) === 'Y') {
                model.setValue(r, column_name, '');
            }
        }
        catch(err) {
        }
    });
};



//
// RENDER ACTION MENU BELOW CURRENT BUTTON
//
const show_action_menu = function(e) {
    e.preventDefault();
    e.stopPropagation();
    //
    var $id = $(this).attr('id');  // e.target.id, this.triggeringElement.id;
    var pos = $('button#' + $id).offset();
    console.log('BUTTON', $id, pos, 'MENU', $('div.ACTION_MENU').offset(), $('div.ACTION_MENU[data-id="' + $id + '"]'));
    //
    $('div.ACTION_MENU').css({
        display   : 'none'
    });
    $('div.ACTION_MENU[data-id="' + $id + '"]').css({
        display   : 'block',
        position  : 'fixed',
        top       : pos.top,
        left      : pos.left
    });
    //$('div.ACTION_MENU[data-id="' + $id + '"] a:first').focus();
};



//
// RESET TABS ON PAGE RESET EVEN IF THEY HAVE MEMORY
//
const reset_tabs = function() {
    // check if page reset was requested
    if (window.location.search.includes('&clear=') || window.location.search.includes('?clear=')) {
        $('div.t-TabsRegion.js-useLocalStorage').each(function() {
            var region_id   = $(this).attr('id');
            var key         = 'ORA_WWV_apex.apexTabs.' + apex.env.APP_ID + '.' + apex.env.APP_PAGE_ID + '.' + region_id + '.activeTab';
            var value       = sessionStorage.getItem(key);
            console.log('RESET_TABS', region_id, key, value);
            sessionStorage.setItem(key, '');
        });
    }
};

