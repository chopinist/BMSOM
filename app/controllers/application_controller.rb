class ApplicationController < ActionController::Base
  require 'bcrypt'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale

  private

    def set_locale
      I18n.locale = params[:locale] if params[:locale].present?
    end

    def default_url_options(options={})
      { locale: I18n.locale }
    end

    def confirm_logged_in

      remember_tokens = RememberToken.where(:user_id => cookies[:user_id])

      remember_tokens.each do |token|
        if(BCrypt::Password.new(token.remember_token) == cookies[:remember_token])
          return true
        end
      end

      if session[:user_id]
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

end
