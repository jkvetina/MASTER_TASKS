// ----------------------------------------
// Page: 0 - Global Page > Dynamic Action: DIALOG_CLOSED > When > JavaScript Expression

window

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

