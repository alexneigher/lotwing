class DailyChecklist < ApplicationRecord
  belongs_to :dealership
  has_many :checklist_items, dependent: :destroy

  has_many :uncompleted_red_level_notifications, -> { where(item_tier: "red", completed_at: nil)} , class_name: 'ChecklistItem'

  has_many :red_level_notifications, -> { where(item_tier: "red")} , class_name: 'ChecklistItem'

  has_many :uncompleted_yellow_level_notifications, -> { where(item_tier: "yellow", completed_at: nil)}, class_name: 'ChecklistItem'


  # custom dealership specific config include
  #  include_check_for_test_drives_longer_than -> if present include a check for test drives

  def test_drive_check_duration
    dealership.dealership_configuration.include_check_for_test_drives_longer_than
  end

  def should_check_for_test_drives?
    test_drive_check_duration.present? && test_drive_check_duration > 0
  end
end
