//= require variables
//= require functions
<% js_files.each do |file| %>
//= require lib/<%= file %>
<% end %>
<% js_dirs.each do |dir| %>
//= require_tree ./lib/<%= dir %>
<% end %>
//= require_tree ./modules
//= require app
//= require main
