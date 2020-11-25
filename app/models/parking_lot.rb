class ParkingLot < ApplicationRecord
  belongs_to :dealership
  has_many :shapes
end
