// ----------------------------------------
// Page: 0 - Global Page > Dynamic Action: DIALOG_CLOSED > When > JavaScript Expression

window

// ----------------------------------------
// Page: 0 - Global Page > Dynamic Action: SUBMIT_AND_DISABLE_BUTTON > Action: Execute JavaScript Code > Settings > Code

var button_id = this.triggeringElement.getAttribute('id');
console.log('SUBMIT_AND_DISABLE_BUTTON:', button_id, this);
document.getElementById(button_id).disabled = true;
apex.submit(button_id);


// ----------------------------------------
// Page: 0 - Global Page > Dynamic Action: SUBMIT_CHANGED_SELECTBOX > Action: Execute JavaScript Code > Settings > Code

var item_id = this.triggeringElement.getAttribute('id');
console.log('SUBMIT_CHANGED_SELECTBOX:', item_id);
apex.submit(item_id);


// ----------------------------------------
// Page: 0 - Global Page > Dynamic Action: CHECK_SESSION > Action: Execute JavaScript Code > Settings > Code

check_session();

// ----------------------------------------
// Page: 0 - Global Page > Dynamic Action: CLOSE_DIALOG > Action: Confirm > Client-side Condition > JavaScript Expression

apex.page.isChanged()

// ----------------------------------------
// Page: 0 - Global Page > Dynamic Action: DIALOG_CLOSED > Action: Execute JavaScript Code > Settings > Code

if (this.data && this.data.successMessage && this.data.successMessage.text) {
    show_success(this.data.successMessage.text);
}

