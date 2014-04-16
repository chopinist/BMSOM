class PasswordRecoveryToken < ActiveRecord::Base

  belongs_to :user

end
