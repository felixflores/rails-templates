# Password reset views
file "app/views/password_resets/edit.html.erb", <<-CODE
<h1>Change My Password</h1>
<% form_for @user, :url => password_reset_path, :method => :put do |f| %>
  <%= f.error_messages %>
  <%= f.label :password %><br />
  <%= f.password_field :password %><br />
  <br />
  <%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation %><br />
  <br />
  <%= f.submit "Update my password and log me in" %>
<% end %>
CODE

file "app/views/password_resets/new.html.erb", <<-CODE
<h1>Forgot Password</h1>
<p>Fill out the form below and instructions to reset your password will be emailed to you:</p>
<% form_tag password_resets_path do %>
  <p>
    <label>Email:</label> 
    <%= text_field_tag "email" %>  
  </p>
  <%= submit_tag "Reset my password" %>
<% end %>
CODE

file "app/controllers/password_resets_controller.rb", <<-CODE
class PasswordResetsController < ApplicationController  
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
 
  def create
    @user = User.find_by_email(params[:email])
    if @user  
      UserMailer.deliver_password_reset_instructions(@user)
      flash[:notice] = "Instructions to reset your password have been "
      flash[:notice] << "emailed to you. Please check your email."
      redirect_to root_url
    else
      flash[:notice] = "No user was found with that email address"
      render :action => :new
    end
  end 
  
  def update  
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save  
      flash[:notice] = "Password successfully updated"
      redirect_to root_url
    else  
      render :action => :edit
    end  
  end  

  private  
  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])
    unless @user  
      flash[:notice] = "We're sorry, but we could not locate your account. "
      flash[:notice] << "If you are having issues try copying and pasting the URL "
      flash[:notice] << "from your email into your browser or restarting the "
      flash[:notice] << "reset password process."
      redirect_to login_path
    end  
  end
end
CODE

# Password reset routes
route "map.resources :password_resets"

# Mailer

file "app/models/user_mailer.rb", <<-CODE
class UserMailer < ActionMailer::Base
  default_url_options[:host] = APP_CONFIG["host"]

  def password_reset_instructions(user)
    recipients    user.email
    from          "Floencode.com"
    subject       "Password Reset Instructions"
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
CODE


file "test/unit/user_mailer_test.rb", <<-CODE
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # replace this with your real tests
  test "the truth" do
    assert true
  end
end
CODE
