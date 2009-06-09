file "app/views/layouts/application.html.erb", <<-CODE
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<title><%= @page_title || APP_CONFIG[:site_name] %></title>
<meta http-equiv="content-type" content="text/xhtml; charset=utf-8" />
<meta http-equiv="imagetoolbar" content="no" />
<meta name="distribution" content="all" />
<meta name="robots" content="all" />  
<meta name="resource-type" content="document" />
<meta name="MSSmartTagsPreventParsing" content="true" />
<%= stylesheet_link_tag :all %>
<%= javascript_include_tag :defaults %>
</head>
<body>
<div id="container">
  <div id="header">
    <ul>
      <% if !current_user %>
        <li><%= link_to "Register", register_path %></li>
        <li><%= link_to "Log In", login_path %></li>
      <% else %>
        <li><%= link_to "Settings", edit_user_path(current_user) %></li>
        <li><%= link_to "Logout", logout_path, :confirm => "Are you sure you want to logout?" %></li>
      <% end %>
    </ul>
  </div>
  <div id="content">
    <%= flash_messages %>
    <%= yield :layout %>
  </div>
</div>
</body>
</html>
CODE

file "app/helpers/application_helper.rb", <<-CODE
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
      %w(notice warning error).each do |msg|
        messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-\#{msg}") unless flash[msg.to_sym].blank?
    end
      messages
  end
end
CODE