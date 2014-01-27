//= require lib/angular/angular
//= require lib/angular/angular-animate
<% if is_foundation? %>
//= require lib/modernizr/modernizr
//= require lib/foundation/js/foundation
<% end %>
<% if is_ionic? %>
//= require lib/ionic
<% end %>
//= require lib/angular
//= require lib/angular-animate
//= require lib/angular-route
//= require lib/angular-touch
//= require lib/angular-sanitize
//= require lib/angular-gestures
<% if is_ionic? %>
//= require lib/ionic-angular
<% end %>
//= require app
//= require main
