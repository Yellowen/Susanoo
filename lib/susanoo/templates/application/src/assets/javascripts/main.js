// Add an event handler on `deviceready` event which is like document ready
// on normal web pages. `deviceready` event dispatch by **cordova**
document.addEventListener("deviceready", onDeviceReady, false);

// Device Ready event handler
function onDeviceReady() {
  // Bootstrap and run angular application
  angular.bootstrap(document, ["Application"]);
}
$(function(){
    if (window.debug === true) {
        console.log("Run in debug mode.");
        onDeviceReady();
    }
});
