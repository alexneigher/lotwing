class Dealership < ApplicationRecord
  has_many :users
  has_many :shapes
  has_many :vehicles
end
