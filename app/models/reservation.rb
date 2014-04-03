class Reservation < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :user
  belongs_to :room

  validates_uniqueness_of :id
  validate :current_time
  validate :limit_quantity
  validate :can_reserve_with_grand_piano

  scope :total, lambda { where(:time => DateTime.now.beginning_of_day..5.days.from_now) }
  scope :active_total, lambda { where(:time => DateTime.now.beginning_of_hour..5.days.from_now) }
  scope :active_today, lambda { where(:time => DateTime.now.beginning_of_hour..DateTime.now.end_of_day) }
  scope :for_today, lambda { where(:time => DateTime.now.beginning_of_day..DateTime.now.end_of_day) }

  def limit_quantity
    if !self.user.admin
      if self.time.to_date == Date.today
        if self.user.reservations.for_today.count >= 2
          errors.add(:base, 'You can only reserve two hours per day')
        elsif self.user.reservations.active_total.count >= 2
          errors.add(:base, 'You can only reserve two hours')
        end
      elsif self.user.reservations.active_total.count >= 2
        errors.add(:base, 'You can only reserve two hours')
      end
    end
  end

  def current_time
    if Time.now > self.time.end_of_hour
      errors.add(:base, 'Time passed')
    end
  end

  def can_reserve_with_grand_piano
    if !self.user.admin
      if self.user.instrument != 'Piano' && self.room.contains_grand_piano &&
          Time.now < Time.parse("20:00") && self.time.to_date != Date.today
        errors.add(:base, 'Room reserved for pianists until 20:00')
      end
    end
  end

end
