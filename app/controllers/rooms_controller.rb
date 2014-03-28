class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(safe_params)

    if @room.save
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(safe_params)
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def destroy
    @room = Room.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end

  private
  def safe_params
    params.require(:room).permit(:id, :name, :contains_grand_piano)
  end
end
