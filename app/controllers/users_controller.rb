class UsersController < ApplicationController
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(safe_params)
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end

  private
  def safe_params
    params.require(:user).permit(:id, :email, :first_name, :last_name, :admin, :instrument, :username, :password, :password_confirmation)
  end
end
