class UsersController < ApplicationController
  before_filter :redirect_to_login
  before_filter :set_user, :redirect_not_admin, :only => [:edit, :update, :destroy]
  before_filter :restrict_user_access_from_users, :except => [:reservations]

  #TODO: When user changes details he should confirm the old password
  #TODO: If user deletes himself there is a redirect loop

  def index
    @users = User.where("first_name LIKE ? OR last_name like ?",
                        "%#{params[:search]}%", "%#{params[:search]}%").paginate(:per_page => 10,:page => params[:page])
    if @users.count == 0
      flash.now[:warning] = t("user.search.no_results")
    end
  end

  def reservations
    @rooms = Room.all
    @reservations = Reservation.active_total.joins(:room).order('(rooms.name * 1) asc')
  end

  def manage
    @users = User.all.order(:last_name)
  end

  def new
    @user = User.new
  end

  def handle_table
    table_all_users_id = []
    added_users_id = []
    blank_users_id = []
    updated_users_success = 0


    flash[:notice] = ""
    flash[:error] = ""

    (0..params[:data].length-1).each do |str|
      if params[:data][str.to_s][:id]
        table_all_users_id << params[:data][str.to_s][:id].to_i
      end
      if !(params[:data][str.to_s][:email].blank? && params[:data][str.to_s][:first_name].blank? &&
          params[:data][str.to_s][:last_name].blank? && params[:data][str.to_s][:instrument].blank?)
        if(!User.find_by_id(params[:data][str.to_s][:id].to_i))
        @user = User.new
        @user.email = params[:data][str.to_s][:email]
        @user.first_name = params[:data][str.to_s][:first_name]
        @user.last_name = params[:data][str.to_s][:last_name]
        @user.instrument = params[:data][str.to_s][:instrument]
        @user.password = 'bmsom123'
        @user.password_confirmation = 'bmsom123'
        @user.username = @user.email
        if @user.save
          added_users_id << @user.id
        else
          flash[:error] += t("multi_users.add_error") + ': ' +
              ' "' + @user.first_name.to_s + '" ' +
              ' "' + @user.last_name.to_s + '" ' +
              ' "' + @user.instrument.to_s + '" ' +
              ' "' + @user.email.to_s + '" - '

          @user.errors.full_messages.each do |msg|
            flash[:error] += msg + '; '
          end
          flash[:error] += '<br />'
        end
      else
        @user = User.find_by_id(params[:data][str.to_s][:id].to_i)

        if(@user)
           @user.first_name = params[:data][str.to_s][:first_name]
           @user.last_name = params[:data][str.to_s][:last_name]
           @user.instrument = params[:data][str.to_s][:instrument]
           @user.email = params[:data][str.to_s][:email]

          if @user.changed?
            if @user.save
              updated_users_success += 1
            else
              flash[:error] += t("multi_users.row") + ' ' + (str+1).to_s + ': ' + t("multi_users.details") +
                  ' "' + @user.first_name.to_s + '" ' +
                  ' "' + @user.last_name.to_s + '" ' +
                  ' "' + @user.instrument.to_s + '" ' +
                  ' "' + @user.email.to_s + '" - '

              @user.errors.full_messages.each do |msg|
                flash[:error] += msg + '; '
              end
              flash[:error] += '<br />'
            end
          end
        end
      end
      else
        if User.find_by_id(params[:data][str.to_s][:id].to_i)
          blank_users_id << params[:data][str.to_s][:id].to_i
        end
      end

    end
    users_for_removal = User.connection.select_values(User.select("id").to_sql) - table_all_users_id - added_users_id + blank_users_id

    users_for_removal.each do |user|
      User.find_by_id(user).destroy
    end

    if added_users_id.length > 0
      flash[:notice] += added_users_id.length.to_s + ' ' + t("multi_users.plural") + ' ' + t("multi_users.added") + '<br />'
    end

    if updated_users_success > 0
      flash[:notice] += updated_users_success.to_s + ' ' + t("multi_users.plural") + ' ' + t("multi_users.updated") + '<br />'
    end

    if users_for_removal.length > 0
      flash[:notice] += users_for_removal.length.to_s + ' ' + t("multi_users.plural") + ' ' + t("multi_users.removed") + '<br />'
    end

    redirect_to(:action => 'manage')
  end

  def create
    @user = User.new(safe_params)
    if @user.save
      flash.now[:notice] = @user.username + " " + t("new_user.success")
      respond_to do |format|
        format.js { @user = User.new }
        format.html { redirect_to(:action => 'index') }
      end
    else
      flash.now[:error] = t("user.error")
      respond_to do |format|
        format.js
        format.html { render 'new' }
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(safe_params)
      flash.now[:notice] = @user.username + " " + t("edit_user.success")
      respond_to do |format|
        format.js
        format.html { redirect_to(:action => 'index') }
      end
    else
      flash.now[:error] = t("user.error")
      respond_to do |format|
        format.js
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    flash.now[:notice] = @user.username + " " + t("delete_user.success")
    @user.destroy
    respond_to do |format|
      format.js { @users = User.where("first_name LIKE ? OR last_name like ?",
                                          "%#{params[:search]}%", "%#{params[:search]}%")
                                          .paginate(:per_page => 10,:page => params[:page]) }
      format.html { redirect_to(:action => 'index') }
    end
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

    def restrict_user_access_from_users
      if !confirm_admin && params[:id] != (session[:user_id].to_s || cookies[:user_id]).to_s
        redirect_to new_user_reservation_path(session[:user_id] || cookies[:user_id])
      end
    end
end
