// Add an event handler on `deviceready` event which is like document ready
// on normal web pages. `deviceready` event dispatch by **cordova**
document.addEventListener("deviceready", onDeviceReady, false);

// Device Ready event handler
function onDeviceReady() {
  <% if is_foundation? %>
  $(document).foundation();
  <% end %>
  // Bootstrap and run angular application
  angular.bootstrap(document, ["Application"]);
}
