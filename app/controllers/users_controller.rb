class UsersController < ApplicationController
  before_filter :redirect_not_admin, :only => [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(safe_params)

    if @user.save
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(safe_params)
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def destroy
    @user.destroy
    redirect_to(:action => 'index')
  end

  private
    def safe_params
      params.require(:user).permit(:id, :email, :first_name, :last_name, :admin, :instrument,
                                   :username, :password, :password_confirmation)
    end

    def set_user
      @user = User.find_by_id(params[:id])
      if !@user
        redirect_to users_path
      end
    end
end
