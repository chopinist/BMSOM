class User < ActiveRecord::Base

  has_secure_password

  has_many :reservations
  has_many :remember_tokens

  validates_presence_of :first_name,
                        :last_name,
                        :username,
                        :password,
                        :password_confirmation


end
