class ApplicationController < ActionController::Base
  require 'bcrypt'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale, :set_admin

  #TODO: Heroku stop idling

  def set_admin
    @admin = confirm_admin
  end

  def confirm_logged_in

    remember_tokens = RememberToken.where(:user_id => cookies[:user_id])

    remember_tokens.each do |token|
      if(BCrypt::Password.new(token.remember_token) == cookies[:remember_token] && User.find_by_id(cookies[:user_id]))
        return true
      end
    end

    if session[:user_id] && User.find_by_id(session[:user_id])
      return true
    else
      return false
    end
  end

  def redirect_to_login
    unless confirm_logged_in
      redirect_to(:controller => 'login',:action => 'index')
    end
  end

  def confirm_admin
    user = User.find_by_id(session[:user_id] || cookies[:user_id])
    if !user || !user.admin
      return false
    else
      return true
    end
  end

  def restrict_user_access
    if !confirm_admin && params[:user_id] != (session[:user_id].to_s || cookies[:user_id]).to_s
      redirect_to new_user_reservation_path(session[:user_id] || cookies[:user_id])
    end
  end

  def redirect_not_admin
    unless confirm_admin
      new_user_reservation_path(session[:user_id] || cookies[:user_id])
    end
  end

  private

    def set_locale
      I18n.locale = params[:locale] if params[:locale].present?
    end

    def default_url_options(options={})
      { locale: I18n.locale }
    end


end
