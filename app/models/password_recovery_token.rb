class PasswordRecoveryToken < ActiveRecord::Base

  belongs_to :user

  scope :active, lambda { where("created_at >= ?",Time.now - 10.minutes) }

end
