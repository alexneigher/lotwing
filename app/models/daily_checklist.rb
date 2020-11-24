class DailyChecklist < ApplicationRecord
  belongs_to :dealership
  has_many :checklist_items, dependent: :destroy

  has_many :notes
  has_many :uncompleted_sales_manager_red_level_notifications, -> { where(item_tier: "sales_manager_red", completed_at: nil)} , class_name: 'ChecklistItem'
  has_many :sales_manager_red_level_notifications, -> { where(item_tier: "sales_manager_red")} , class_name: 'ChecklistItem'

  has_many :uncompleted_sales_manager_yellow_level_notifications, -> { where(item_tier: "sales_manager_yellow", completed_at: nil)}, class_name: 'ChecklistItem'
  has_many :sales_manager_yellow_level_notifications, -> { where(item_tier: "sales_manager_yellow")} , class_name: 'ChecklistItem'

  has_many :uncompleted_service_manager_yellow_level_notifications, -> { where(item_tier: "service_manager_yellow", completed_at: nil)}, class_name: 'ChecklistItem'
  has_many :service_manager_yellow_level_notifications, -> { where(item_tier: "service_manager_yellow")} , class_name: 'ChecklistItem'

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
    dealership.dealership_configuration.sales_managers_custom_reminder_checklist_items || []
  end

   def service_manager_custom_items
    dealership.dealership_configuration.service_managers_custom_reminder_checklist_items || []
  end

  def should_check_for_service_loaner?
    dealership.dealership_configuration.include_check_for_srv_loaner_older_than.present? &&
      dealership.dealership_configuration.include_check_for_srv_loaner_older_than > 0
  end

  def service_loaner_duration
    dealership.dealership_configuration.include_check_for_srv_loaner_older_than
  end

  def should_run_today_for?(team_name)
    current_weekday = Time.current.in_time_zone("US/Pacific").wday

    if team_name == :sales
      dealership
        .dealership_configuration
        .days_of_the_week_to_show_sales_manager_notifications[current_weekday].to_i

    elsif team_name == :service
      dealership
        .dealership_configuration
        .days_of_the_week_to_show_service_manager_notifications[current_weekday].to_i
    end
  end

  def any_items_for?(team_name)
    if team_name == :sales
      checklist_items
        .where(item_tier: ["sales_manager_red", "sales_manager_yellow"])
        .empty?
    elsif team_name == :service
      checklist_items
        .where(item_tier: ["service_manager_yellow"])
        .empty?
    end
  end

  def all_items_completed_for?(team_name)
    if team_name == :sales
      checklist_items
        .where(item_tier: ["sales_manager_red", "sales_manager_yellow"])
        .all?{ |i| i.completed_at.present? }
    elsif team_name == :service
      checklist_items
        .where(item_tier: ["service_manager_yellow"])
        .all?{ |i| i.completed_at.present? }
    end


  end

end
