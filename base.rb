template_directory = "/Users/Felix/Sites/Projects/rails-templates/"

# Basic Site Information
site_name = ask "Name of site website."
port = ask "App port."
host = ask "App hostname."

# --------------------------------- Initialize git --------------------------------- #
# Copy database.yml for distribution use
run "cp config/database.yml config/database.yml.example"

# Delete unnecessary files
run "rm README"
run "rm doc/README_FOR_APP"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"

git :init

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/example_database.yml"

git :add => ".", :commit => "-m 'initial commit'"

# ----------------------------------- Install Plugins ------------------------------ #
gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
file "test/factories.rb", ""
rake "gems:install"
git :add => ".", :commit => "-m 'Factory Girl added'"

gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
rake "gems:install"
git :add => ".", :commit => "-m 'Shoulda added'"

gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
git :add => ".", :commit => "-m 'mislav-will_paginate added'"

gem 'faker'
git :add => ".", :commit => "-m 'faker added'"

load_template "#{template_directory}base_webrat.rb"

plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git', :submodule => true
git :add => ".", :commit => "-m 'Asset packager added'"

file 'config/asset_packages.yml', <<-CODE
--- 
javascripts: 
- base: 
  - prototype
  - effects
  - dragdrop
  - controls
  - application
stylesheets: 
- base:
  - base
CODE

# --------------------------------------- Config Files --------------------------------- #

file 'config/config.yml', <<-CODE
development:
  site_name: "#{site_name}"
  host: "localhost:#{port}"
test:
  site_name: "#{site_name}"
  host: "localhost:#{port}"
production:
  site_name: "#{site_name}"
  host: "#{host}"
CODE

file 'config/initializers/load_config.rb', <<-CODE
APP_CONFIG = YAML.load_file("#{"\#{RAILS_ROOT}"}/config/config.yml")[RAILS_ENV]
SITE_NAME = APP_CONFIG['site_name']
HOST = APP_CONFIG['host']
DO_NOT_REPLY = APP_CONFIG['do_no_reply']
CODE

git :add => ".", :commit => "-m 'Created config file'"

# --------------------------------------- Rake DB ------------------------------------- #
rake "db:create:all"
rake "db:migrate"