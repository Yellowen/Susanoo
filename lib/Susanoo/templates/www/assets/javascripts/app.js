document.addEventListener("deviceready", onDeviceReady, false);

// device APIs are available
//
function onDeviceReady() {
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
