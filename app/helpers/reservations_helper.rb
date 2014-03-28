module ReservationsHelper
  def generate_reservation_dates(quan)
    x = 0.days
    y = []

    if Time.now.hour > 20
      todate = Time.now
    else
      todate = Time.now - 1.day
    end
    todate = Time.now - 1.day
    for i in 0..quan-1
      if x>0
        x=0
      end

      todate += 1.day
      if todate.friday?
        x = 2.days
      elsif todate.saturday?
        x = 1.day
      end
      todate += x

      y << [l(todate, :format => :custom) + ', ' + l(todate, :format => :il_date_words) , l(todate, :format => :il_date)]
    end
    arr = y
  end

  def generate_reservation_time()

    arr = []

      for i in 8..20
        arr << i.to_s + ":00"
      end

    return arr
  end
end
