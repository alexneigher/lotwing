class Shape < ApplicationRecord
  belongs_to :dealership
  
  has_many :tags
  has_many :vehicles, through: :tags

  has_one :current_vehicle, -> { where active: true }, class_name: 'Tag'
  
  has_one :vehicle, through: :current_vehicle, source: :vehicle
  
  enum shape_type: [:parking_space, :parking_area, :building, :parking_lot]
end
