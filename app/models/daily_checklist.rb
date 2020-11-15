class DailyChecklist < ApplicationRecord
  belongs_to :dealership
  has_many :checklist_items, dependent: :destroy

  has_many :uncompleted_red_level_notifications, -> { where(item_tier: "red", completed_at: nil)} , class_name: 'ChecklistItem'
  has_many :red_level_notifications, -> { where(item_tier: "red")} , class_name: 'ChecklistItem'

  has_many :uncompleted_yellow_level_notifications, -> { where(item_tier: "yellow", completed_at: nil)}, class_name: 'ChecklistItem'
  has_many :yellow_level_notifications, -> { where(item_tier: "yellow")} , class_name: 'ChecklistItem'


  # custom dealership specific config include
  #  include_check_for_test_drives_longer_than -> if present include a check for test drives
  def should_check_for_test_drives?
    test_drive_check_duration.present? && test_drive_check_duration > 0
  end

  def test_drive_check_duration
    dealership.dealership_configuration.include_check_for_test_drives_longer_than
  end

  # include_check_for_used_ucv_older_than -> a check to see if we need to call out used UCVs
  def should_check_for_used_ucv?
    used_ucv_check_duration.present? && used_ucv_check_duration > 0
  end

  def used_ucv_check_duration
    dealership.dealership_configuration.include_check_for_used_ucv_older_than
  end

  # include_check_for_new_ucv_older_than -> a check to see if we need to call out used UCVs
  def should_check_for_new_ucv?
    new_ucv_check_duration.present? && new_ucv_check_duration > 0
  end

  def new_ucv_check_duration
    dealership.dealership_configuration.include_check_for_new_ucv_older_than
  end

  def sales_manager_custom_items
    dealership.dealership_configuration.sales_managers_custom_reminder_checklist_items
  end

end
