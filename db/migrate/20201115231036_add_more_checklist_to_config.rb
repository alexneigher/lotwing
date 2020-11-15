class AddMoreChecklistToConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :dealership_configurations, :include_check_for_used_ucv_older_than, :integer
    add_column :dealership_configurations, :include_check_for_new_ucv_older_than, :integer

    add_column :dealership_configurations, :sales_managers_custom_reminder_checklist_items, :jsonb

    add_column :dealership_configurations, :days_of_the_week_to_show_sales_manager_notifications, :text, array: true, default: [0,0,0,0,0,0,0]


    add_column :dealership_configurations, :include_check_for_srv_loaner_older_than, :integer
    add_column :dealership_configurations, :service_managers_custom_reminder_checklist_items, :jsonb

    add_column :dealership_configurations, :days_of_the_week_to_show_service_manager_notifications, :text, array: true, default: [0,0,0,0,0,0,0]


  end
end
