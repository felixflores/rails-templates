# User session model
file 'app/models/user_session.rb', <<-CODE
class UserSession < Authlogic::Session::Base
end
CODE

# User session views
file 'app/views/user_sessions/new.html.erb', <<-CODE
<h1>Login</h1>

<% form_for @user_session do |f| %>
  <%= f.error_messages %>
  <p>
    <%= f.label "Username or Email Address" %> 
    <%= f.text_field :username %>
  </p>
  <p>
    <%= f.label :password %> 
    <%= f.password_field :password %>
  </p>
  <p><%= f.submit "Login" %></p>
<% end %>

<%= link_to "Forgot Password", new_password_reset_path %>
CODE

# User sessions controller
file 'app/controllers/user_sessions_controller.rb', <<-CODE
class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end
end
CODE

# Helper
file "app/helpers/users_sessions_helper.rb", <<-CODE
module UsersSessionsHelper

end
CODE

# Functional test
file "test/functional/user_sessions_controller_test.rb", <<-CODE
require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_session" do
    assert_difference('UserSession.count') do
      post :create, :user_session => { }
    end

    assert_redirected_to user_session_path(assigns(:user_session))
  end

  test "should show user_session" do
    get :show, :id => user_sessions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_sessions(:one).to_param
    assert_response :success
  end

  test "should update user_session" do
    put :update, :id => user_sessions(:one).to_param, :user_session => { }
    assert_redirected_to user_session_path(assigns(:user_session))
  end

  test "should destroy user_session" do
    assert_difference('UserSession.count', -1) do
      delete :destroy, :id => user_sessions(:one).to_param
    end

    assert_redirected_to user_sessions_path
  end
end
CODE

# Unit test
file "test/unit/user_session_test.rb", <<-CODE
require 'test_helper'

class UserSessionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
CODE

# Unit test helper
file "test/unit/helpers/user_sessions_helper_test.rb", <<-CODE
require 'test_helper'

class UserSessionsHelperTest < ActionView::TestCase
end
CODE

# User session routes 
route "map.login \"login\", :controller => \"user_sessions\", :action => \"new\""
route "map.logout \"logout\", :controller => \"user_sessions\", :action => \"destroy\""
route "map.resources :user_sessions"