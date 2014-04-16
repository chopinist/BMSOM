class ReservationsController < ApplicationController
  before_action :redirect_to_login, :set_user
  before_action :restrict_user_access, :except => [:new]

  def index
    @reservations = @user.reservations.active_total
  end

  def new
    @reservation = @user.reservations.build
    @rooms = Room.all.order("name ASC")
  end

  def create
    @reservation = @user.reservations.build(safe_params)

    if !params.has_key?(:room_name)

      respond_to do |format|
        format.js
        format.html { render 'new' }
      end
    else
      @reservation.room_id = Room.find_by_name(params[:room_name]).id
      @reservation.time = Time.parse("#{params[:res_date]} #{params[:res_time]}")
      if @reservation.save
        flash.now[:notice] = t("new_reservation.success1") + params[:room_name] +
                             t("new_reservation.success2") +
                              params[:res_date] +
                             t("new_reservation.success3") + params[:res_time]

        respond_to do |format|
          format.js { @reservation = @user.reservations.build }
          format.html { redirect_to new_user_reservation_path }
        end
      else
        errors_string = ""
        @reservation.errors.full_messages.each do |error|
          if @reservation.errors.count > 1 && error != @reservation.errors.full_messages.last
            errors_string += error + "; "
          else
            errors_string += error
          end
        end
        flash.now[:error] = errors_string
        respond_to do |format|
          format.js
          format.html { render 'new' }
        end
      end
   end
  end

  def destroy
    @reservation = Reservation.find_by_id(params[:id])

    if @reservation.nil?
      flash.now[:error] = t("remove_reservation.error_no_id")
    elsif Time.now + 3.hours >= @reservation.time
      flash.now[:error] = t("remove_reservation.remove_time")
    else
      @reservation.destroy
      flash.now[:notice] = t("remove_reservation.success")
    end

    respond_to do |format|
      format.js { @reservations = @user.reservations.active_total }
      format.html { render 'index' }
    end
  end

  private
    def safe_params
      params.permit(:id, reservations_attributes: [:room_id, :time])
    end

    def set_user
      @user = User.find_by_id(params[:user_id])
      if !@user
        redirect_to new_user_reservation_path(session[:user_id] || cookies[:user_id])
      end
    end
end
