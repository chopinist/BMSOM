class RoomsController < ApplicationController
  before_filter :redirect_to_login
  before_filter :set_room, :redirect_not_admin, :only => [:edit, :update, :destroy]
  before_filter :admin?

  #TODO: Rooms ajaxing

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(safe_params)

    if @room.save
      flash.now[:notice] = @room.name + " " + t("new_room.success")
      respond_to do |format|
        format.js { @room = Room.new }
        format.html { redirect_to(:action => 'index') }
      end
    else
      flash.now[:error] = t("room.error")
      respond_to do |format|
        format.js
        format.html { render 'new' }
      end
    end
  end

  def edit
  end

  def update
    if @room.update_attributes(safe_params)
      flash.now[:notice] = @room.name + " " + t("edit_room.success")
      respond_to do |format|
        format.js
        format.html { redirect_to(:action => 'index') }
      end
    else
        flash.now[:error] = t("room.error")
        respond_to do |format|
          format.js
          format.html { render 'edit' }
        end
    end
  end

  def destroy
    @room.destroy
    redirect_to(:action => 'index')
  end

  private
    def safe_params
      params.require(:room).permit(:id, :name, :contains_grand_piano)
    end

    def set_room
      @room = Room.find_by_id(params[:id])
      if !@room
        redirect_to rooms_path
      end
    end

  def admin?
    @admin = confirm_admin
  end
end
