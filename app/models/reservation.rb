class Reservation < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :user
  belongs_to :room

  validate :uniqueness_of_reservation
  validate :current_time
  validate :limit_quantity
  validate :can_reserve_with_grand_piano

  scope :total, lambda { where(:time => DateTime.now.beginning_of_day..6.days.from_now.end_of_day) }
  scope :active_total, lambda { where(:time => DateTime.now.beginning_of_hour..6.days.from_now.end_of_day) }
  scope :active_today, lambda { where(:time => DateTime.now.beginning_of_hour..DateTime.now.end_of_day) }
  scope :for_today, lambda { where(:time => DateTime.now.beginning_of_day..DateTime.now.end_of_day) }

  def limit_quantity
    if !self.user.admin
      if self.time.to_date == Date.today
        if self.user.reservations.for_today.count >= 2
          errors.add(:base,I18n.t("new_reservation.no_more_day"))
        elsif self.user.reservations.active_total.count >= 2
          errors.add(:base,I18n.t("new_reservation.no_more"))
        end
      elsif self.user.reservations.active_total.count >= 2
        errors.add(:base,I18n.t("new_reservation.no_more"))
      end
    end
  end

  def current_time
    if Time.now > self.time.end_of_hour
      errors.add(:base,I18n.t("new_reservation.time_passed"))
    end
  end

  def can_reserve_with_grand_piano
    if !self.user.admin
      if self.user.instrument != 'Piano' && self.room.contains_grand_piano &&
          Time.now < Time.parse("20:00") && self.time.to_date != Date.today
        errors.add(:base,I18n.t("new_reservation.grand_pianos_warning"))
      end
    end
  end

  def uniqueness_of_reservation
    if Reservation.where(:time => self.time, :room => self.room).count>0
      errors.add(:base,I18n.t("new_reservation.room") + self.room.name + I18n.t("new_reservation.already_taken"))
    end
  end

end
