class LoginController < ApplicationController
  layout 'public'

  before_action :redirect_to_login, :except => [:index, :logout, :login_attempt]

  def index
    if confirm_logged_in
      redirect_to new_user_reservation_path(session[:user_id] || cookies[:user_id])
    end
  end

  def login_attempt
    user = User.find_by_username(params[:username])
    if user
      authorized_user = user.authenticate(params[:password])
    end
    if authorized_user
      if params[:remember]
        secure_random = SecureRandom.urlsafe_base64
        RememberToken.create(:user_id => authorized_user.id,
                             :remember_token => BCrypt::Password.create(secure_random))
        cookies.permanent[:user_id] =  authorized_user.id
        cookies.permanent[:remember_token] = secure_random
      end
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

    if cookies[:user_id]
      remember_tokens = RememberToken.where(:user_id => cookies[:user_id])

      remember_tokens.each do |token|
        if(BCrypt::Password.new(token.remember_token) == cookies[:remember_token])
          token.destroy
        end
      end

      cookies[:user_id] = nil
      cookies[:remember_token] = nil
    end

    redirect_to(:action => 'index')
  end

end
