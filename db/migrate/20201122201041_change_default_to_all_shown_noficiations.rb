class ChangeDefaultToAllShownNoficiations < ActiveRecord::Migration[5.1]
  def change
    change_column_default :dealership_configurations, :days_of_the_week_to_show_sales_manager_notifications, [1, 1, 1, 1, 1, 1, 1]
    change_column_default :dealership_configurations, :days_of_the_week_to_show_service_manager_notifications, [1, 1, 1, 1, 1, 1, 1]
  end
end
