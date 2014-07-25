class LoginController < ApplicationController
  layout 'public'

  #TODO: When login, if password is in cookie renew the hash

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
      flash[:error] = t("login.wrong_details")
      redirect_to(:action => 'index')
    end
  end

  def recover
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

  def confirm_link
    recovery_token = PasswordRecoveryToken.find_by_recovery_token(params[:recovery_token])

    if !recovery_token || recovery_token.created_at < Time.now - 10.minutes
      flash.now[:error] = t("recover_mail.confirmation.no_token")
    else
      user = User.find(recovery_token.user_id)
      user.update_attributes(:password => 'bmsom123', :password_confirmation => 'bmsom123')
      recovery_token.destroy
      flash.now[:notice] = user.username + t("recover_mail.confirmation.password_reset_ok")
    end
  end

  def send_password
    @user = User.find_by_email(params[:email])

    if !@user
      flash.now[:error] = t("recover_mail.no_email")
      render 'recover'
    elsif @user.password_recovery_tokens.active.count > 0
      flash.now[:error] = t("recover_mail.already_sent")
      render 'recover'
    else
      UserMailer.recover_password(@user,params[:locale]).deliver
      flash.now[:notice] = t("recover_mail.email_sent") + @user.email
      render 'recover'
    end

  end

end
