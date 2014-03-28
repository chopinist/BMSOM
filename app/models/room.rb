class Room < ActiveRecord::Base

  has_many :reservations

  validates_presence_of :name

end
