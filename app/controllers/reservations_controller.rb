class ReservationsController < ApplicationController
  before_action :set_user

  def index
    @reservations = @user.reservations.active_total
  end

  def show
  end

  def new
    @reservation = @user.reservations.build
    @rooms = Room.all.order("name ASC")
  end

  def edit
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
    @reservation = Reservation.find(params[:id]).destroy
    respond_to do |format|
      format.js
      format.html { render 'index' }
    end
  end

  private
    def safe_params
      params.permit(:id, reservations_attributes: [:room_id, :time])
    end

    def set_user
      @user = User.find(params[:user_id])
    end
end
