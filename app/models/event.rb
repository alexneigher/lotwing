class Event < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  has_many :resolutions, dependent: :destroy
  #some of these happen automatically, some of them can be user input
  enum event_type: [:tag, :note, :test_drive, :fuel_vehicle, :odometer_update, :photo_update, :write_up, :mark_sold]
end
