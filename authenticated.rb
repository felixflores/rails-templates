template_directory = "/Users/Felix/Sites/Projects/rails-templates/"
load_template "#{template_directory}base.rb"

root_controller = ask("Root controller for application")

#------------------ install gem -----------------------------------------

gem "authlogic"
rake "gems:install"

generate :scaffold, "#{root_controller}"
run "rm app/views/layouts/#{root_controller.split[0].pluralize}.html.erb"
route "map.root :controller => \"#{root_controller.split[0].pluralize}\""

load_template "#{template_directory}authenticated_application_layout.rb"
load_template "#{template_directory}authenticated_user.rb"
load_template "#{template_directory}authenticated_user_session.rb"
load_template "#{template_directory}authenticated_application_controller.rb"
load_template "#{template_directory}authenticated_password_reset.rb"

rake "db:migrate"
git :add => ".", :commit => "-m 'Authentication added'"