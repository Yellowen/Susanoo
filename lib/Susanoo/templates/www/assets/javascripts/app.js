document.addEventListener("deviceready", onDeviceReady, false);

// device APIs are available
//
function onDeviceReady() {
    <% if is_foundation? %>
    $(document).foundation();
    <% end %>
    showAlert();
}

// alert dialog dismissed
function alertDismissed() {

}

// Show a custom alertDismissed
//
function showAlert() {
    navigator.notification.alert(
        'You are the winner!',  // message
        alertDismissed,         // callback
        'Game Over',            // title
        'Done'                  // buttonName
    );
}
