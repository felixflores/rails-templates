# User Model
file "app/models/user.rb", <<-CODE
class User < ActiveRecord::Base
  acts_as_authentic
end
CODE

# User views
file 'app/views/users/_user.html.erb', <<-CODE
<% form_for @user do |f| %>
  <%= f.error_messages %>
  <p>
    <%= f.label :username %> 
    <%= f.text_field :username %>
  </p>
  <p>
    <%= f.label :email %> 
    <%= f.text_field :email %>
  </p>
  <p>
    <%= f.label :password %> 
    <%= f.password_field :password %>
  </p>
  <p>
    <%= f.label :password_confirmation %> 
    <%= f.password_field :password_confirmation %>
  </p>
  <p><%= f.submit "Submit" %></p>
<% end %>
CODE

file 'app/views/users/edit.html.erb', <<-CODE
<h1>Edit My Account</h1>
<%= render :partial => @user %>
CODE

file 'app/views/users/new.html.erb', <<-CODE
<h1>Register</h1>
<%= render :partial => @user %>
CODE


# User controller
file 'app/controllers/users_controller.rb', <<-CODE
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to root_url
    else
      render :action => :edit
    end
  end
end
CODE

# Helper
file "app/helpers/users_helper.rb", <<-CODE
module UsersHelper
end
CODE

# Functional test
file "test/functional/users_controller_test.rb", <<-CODE
require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => { }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => users(:one).to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => users(:one).to_param, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).to_param
    end

    assert_redirected_to users_path
  end
end
CODE

# Unit test
file "test/unit/user_test.rb", <<-CODE
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
CODE

# Unit test helper
file "test/unit/helpers/users_helper_test.rb", <<-CODE
require 'test_helper'

class UsersHelperTest < ActionView::TestCase
end
CODE

# User routes
route "map.register \"register\", :controller => \"users\", :action => \"new\""
route "map.resources :users"

# User migration
migration_prefix = Integer(Time.now.getgm.strftime("%Y%m%d%H%M%S")) + 1
file "db/migrate/#{migration_prefix}_create_users.rb", <<-CODE
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