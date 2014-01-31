//= require variables
//= require functions
<% js_files.each do |file| %>
//= require lib/<%= file %>
<% end %>
//= require_tree ./modules
//= require app
//= require main
