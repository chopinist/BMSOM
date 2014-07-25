class Room < ActiveRecord::Base

  has_many :reservations

  validates_uniqueness_of :name
  validates_presence_of :name


end
