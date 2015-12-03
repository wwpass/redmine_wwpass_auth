
//----------------JS function called when login button is clicked----------------------------------
function token_auth(sp_name) {
    wwp_set_msg('WWPass Authentication in progress..', ' '); //Set the info message
    wwpass_auth(sp_name, auth_cb);
}

function associate(sp_name, path) {
    wwp_set_msg('WWPass Authentication in progress..', '');
    var form = document.createElement("form");
    form.setAttribute("method", "post");
    form.setAttribute("action", path);
    form.setAttribute("id", "wwpass_form");

    var hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("name", "ticket");
    hiddenField.setAttribute("id", "ticket");
    hiddenField.setAttribute("value", " ");
    form.appendChild(hiddenField);

    document.body.appendChild(form);

    wwpass_auth(sp_name, auth_cb);
}

//-------------- Callback JS function to get ticket or error ---------------------------------------
function auth_cb(status, ticket_or_reason) {
    if (status == WWPass_OK) { //If ticket request handled successfully
        wwp_set_msg('Success', 'WWPass Authentication'); //Set info message
        //Pass ticket to the auth.java and call it
        //post_to_url("startLogin", {ticket: ticket_or_reason});
        set_ticket(ticket_or_reason);
        document.getElementById('wwpass_form').submit();
    } else {
        wwp_set_msg(ticket_or_reason + ' (' + status + ')',
            'Authentication failed'); //If ticket request not handled, return error
    }
}

//--------------JS function to set the informational message---------------------------------------
function wwp_set_msg(message, header) {
    var message = message || '';
    var header = header || '';
    document.getElementById('wwp-message-header').innerHTML = header;
    document.getElementById('wwp-message-p').innerHTML = message;
}

//--------------JS function to set the hidden parameter "puid"-------------------------------------
function set_ticket(ticket) {
    document.getElementsByName('ticket').innerHTML = ticket;
    document.getElementById("ticket").setAttribute("value", ticket);
}

function post_to_url(path, params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
        }
    }

    document.body.appendChild(form);
    form.submit();
}
