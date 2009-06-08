# User Migration
migration_prefix = Integer(Time.now.getgm.strftime("%Y%m%d%H%M%S"))++

migration_file = "#{migration_prefix}_create_user.rb"
file "db/migrate/#{migration_file}", <<-CODE
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false
      t.string :email, :null => false
      
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.string :perishable_token, :null => false
    end
  end

  def self.down
    drop_table :users
  end
end
CODE