class Shape < ApplicationRecord
  belongs_to :dealership

  enum shape_type: [:parking_space, :parking_area, :building, :parking_lot]
end
