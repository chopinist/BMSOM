class User < ActiveRecord::Base

  has_secure_password

  has_many :reservations

  validates_presence_of :first_name,
                        :last_name,
                        :username,
                        :password,
                        :password_confirmation


end
