class Event < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true

  has_many :resolutions, dependent: :destroy
  #some of these happen automatically, some of them can be user input
  enum event_type: [:tag, :note, :test_drive, :fuel_vehicle, :odometer_update, :photo_update, :write_up, :mark_sold, :change_stall, :create_vehicle]


  after_create :notify_dealership, if: Proc.new { self.event_type == 'note' }


  private
    def notify_dealership
      EventMailer.notify_about_note_created(self)
    end
end
