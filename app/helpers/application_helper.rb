module ApplicationHelper
  def available_rooms_array(res_date,res_time)
    rooms = Room.all
    res_datetime = Time.parse("#{res_date} #{res_time}")
    arr = []

    rooms.each do |room|
      unless room.reservations.where(:time => res_datetime).size > 0
        arr << room
      end
    end

    if arr.size == 0
      flash.now[:warning] = "No Available Rooms"
    end

    return arr
  end
end
