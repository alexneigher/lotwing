class Shape < ApplicationRecord
  belongs_to :dealership
  
  has_many :tags
  has_many :vehicles, through: :tags

  has_one :current_vehicle_tag, -> { where active: true }, class_name: 'Tag'
  
  has_one :vehicle, through: :current_vehicle_tag, source: :vehicle
  
  enum shape_type: [:parking_space, :parking_area, :building, :parking_lot]
end
