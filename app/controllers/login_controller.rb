class LoginController < ApplicationController
  layout 'public'

  before_action :redirect_to_login, :except => [:index, :logout, :login_attempt]

  def index
    if confirm_logged_in
      redirect_to new_user_reservation_path(session[:user_id])
    end
  end

  def login_attempt
    user = User.find_by_username(params[:username])
    if user
      authorized_user = user.authenticate(params[:password])
    end
    if authorized_user
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username
      redirect_to new_user_reservation_path(session[:user_id])
    else
      redirect_to(:action => 'index')
    end
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    redirect_to(:action => 'index')
  end

end
