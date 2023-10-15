const init_grid = function() {
    $('#BOARD .STICKY').stickyWidget();
    //
    $('#BOARD').on('dragover',  '.TARGET',  dragover);
    $('#BOARD').on('dragstart', '.CARD',    dragstart);
    $('#BOARD').on('dragend',   '.CARD',    dragend);
};

const dragover = function(e) {
    //
    // ZONE FOR DRAGGING
    //
    e.preventDefault();
    const zone = e.target;
    const curr_card = document.querySelector('#BOARD div.DRAGGING');
    const last_card = insert_above(zone, e.clientY);

    // check source and target
    if (!curr_card || !curr_card.classList.contains('CARD')) {
        return;
    }
    if (!zone.classList.contains('TARGET')) {
        return;
    }
    //
    //console.log('DRAGGING', 'CURR:', curr_card.getAttribute('id'), curr_card, 'ZONE:', zone.getAttribute('id'), last_card);
    //
    if (!curr_card) {
        zone.appendChild(curr_card);
    }
    else {
        zone.insertBefore(curr_card, last_card);
    }
};

const dragstart = function(e) {
    //
    // DRAGGING START
    //
    (e.originalEvent || e).dataTransfer.effectAllowed = 'move';  // get rid of the copy cursor
    //console.log('START', e.target.id, this);
    if (!e.target.classList.contains('CARD')) {
        // when clicking direcly on link, find parent element (card/card)
        if (e.target.parentElement.classList.contains('CARD')) {
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
    const card = document.querySelector('#BOARD div.DRAGGING');
    if (!card) {
        e.preventDefault();
        return;
    }
    card.classList.remove('DRAGGING');
    //
    const target_primary    = e.target.parentElement.getAttribute('id');
    const target_alt        = e.target.parentElement.parentElement.getAttribute('id');
    const target            = target_primary.indexOf('CARD_') === 0 ? target_alt : target_primary;
    const card_id           = card.getAttribute('id').replace('CARD_', '');
    const status_id         = target.replace('STATUS_', '').split('_SWIMLANE_')[0];
    const swimlane_id       = target.replace('STATUS_', '').split('_SWIMLANE_')[1];
    const cards             = document.getElementById(target).querySelectorAll('.CARD');
    //
    var sorted = [];
    cards.forEach(function(card) {
        sorted.push(card.getAttribute('id').replace('CARD_', ''));
    });
    sorted = sorted.join(':');
    //
    console.group('CARD_MOVED');
    console.log('CARD     :', card_id);
    console.log('TARGET   :', target, target_primary, target_alt);
    console.log('STATUS   :', status_id);
    console.log('SWIMLANE :', swimlane_id);
    console.log('SORTED   :', sorted);
    console.groupEnd();
    //
    apex.server.process('UPDATE_CARD',
        {
            x01: card_id,
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
                    show_success(pData);
                    //apex.message.showPageSuccess(pData);
                    //$.event.trigger('REFRESH_GRID');
                }
            }
        }
    );
};

//
// REORDER ELEMENTS IN SAME ZONE
//
const insert_above = (zone, mouseY) => {
    let closest_card   = null;
    let closest_offset = Number.NEGATIVE_INFINITY;
    //
    const cards = zone.querySelectorAll('.CARD:not(.DRAGGING)');
    cards.forEach((card) => {
        const { top } = card.getBoundingClientRect();
        const offset  = mouseY - top;
        //
        if (offset < 0 && offset > closest_offset) {
            closest_offset = offset;
            closest_card   = card;
        }
    });
    //
    return closest_card;
};

