const init_grid = function() {
    $('#BOARD').on('dragover',  '.TARGET',  dragover);
    $('#BOARD').on('dragstart', '.TASK',    dragstart);
    $('#BOARD').on('dragend',   '.TASK',    dragend);
};

const dragover = function(e) {
    //
    // ZONE FOR DRAGGING
    //
    e.preventDefault();
    const zone = e.target;
    const curr_task = document.querySelector('#BOARD div.DRAGGING');
    const last_task = insertAboveTask(zone, e.clientY);

    // check source and target
    if (!curr_task.classList.contains('TASK')) {
        return;
    }
    if (!zone.classList.contains('TARGET')) {
        return;
    }
    //
    //console.log('DRAGGING', 'CURR:', curr_task.getAttribute('id'), curr_task, 'ZONE:', zone.getAttribute('id'), last_task);
    //
    if (!curr_task) {
        zone.appendChild(curr_task);
    }
    else {
        zone.insertBefore(curr_task, last_task);
    }
};

const dragstart = function(e) {
    //
    // DRAGGING START
    //
    (e.originalEvent || e).dataTransfer.effectAllowed = 'move';  // get rid of the copy cursor
    //console.log('START', e.target.id, this);
    if (!e.target.classList.contains('TASK')) {
        // when clicking direcly on link, find parent element (card/task)
        if (e.target.parentElement.classList.contains('TASK')) {
            e.target.parentElement.classList.add('DRAGGING');
        }
        else {
            e.preventDefault();
            return;
        }
    }
    //e.dataTransfer.setData("draggedItem", e.target.id);
    e.target.classList.add('DRAGGING');
};

const dragend = function(e) {
    //
    // DRAGGING END
    //
    //console.log('STOP', e.dataTransfer.getData("draggedItem"));
    const task = document.querySelector('#BOARD div.DRAGGING');
    if (!task) {
        e.preventDefault();
        return;
    }
    task.classList.remove('DRAGGING');
    //
    const target_primary    = e.target.parentElement.getAttribute('id');
    const target_alt        = e.target.parentElement.parentElement.getAttribute('id');
    const target            = target_primary.indexOf('TASK_') === 0 ? target_alt : target_primary;
    const task_id           = task.getAttribute('id').replace('TASK_', '');
    const status_id         = target.replace('STATUS_', '').split('_SWIMLANE_')[0];
    const swimlane_id       = target.replace('STATUS_', '').split('_SWIMLANE_')[1];
    const cards             = document.getElementById(target).querySelectorAll('.TASK');
    //
    var sorted = [];
    cards.forEach(function(task) {
        sorted.push(task.getAttribute('id').replace('TASK_', ''));
    });
    sorted = sorted.join(':');
    //
    console.group('TASK_MOVED');
    console.log('TASK     :', task_id);
    console.log('TARGET   :', target, target_primary, target_alt);
    console.log('STATUS   :', status_id);
    console.log('SWIMLANE :', swimlane_id);
    console.log('SORTED   :', sorted);
    console.groupEnd();
    //
    apex.server.process('UPDATE_TASK',
        {
            x01: task_id,
            x02: status_id,
            x03: swimlane_id,
            x04: sorted
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
            }
        }
    );
};

//
// REORDER ELEMENTS IN SAME ZONE
//
const insertAboveTask = (zone, mouseY) => {
    let closest_task   = null;
    let closest_offset = Number.NEGATIVE_INFINITY;
    //
    const cards = zone.querySelectorAll('.TASK:not(.DRAGGING)');
    cards.forEach((task) => {
        const { top } = task.getBoundingClientRect();
        const offset  = mouseY - top;
        //
        if (offset < 0 && offset > closest_offset) {
            closest_offset = offset;
            closest_task   = task;
        }
    });
    //
    return closest_task;
};

