gem "webrat", :source => "http://gems.github.com"
rake "gems:install"

webrat_config = <<-CODE
Webrat.configure do |config|
  config.mode = :rails
end
CODE

open('test/test_helper.rb', 'a') { |f|
  f.puts webrat_config
}

git :add => ".", :commit => "-m 'Webrat added'"