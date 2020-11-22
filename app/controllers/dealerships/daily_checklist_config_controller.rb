class Dealerships::DailyChecklistConfigController < ApplicationController

  def index
    @dealership = current_user.dealership
  end

  def update
    @dealership = current_user.dealership
    @dealership.dealership_configuration.update!(daily_checklist_config_params.merge(
            days_of_the_week_to_show_sales_manager_notifications: params[:days_of_the_week_to_show_sales_manager_notifications]&.values&.map(&:to_i),
            days_of_the_week_to_show_service_manager_notifications: params[:days_of_the_week_to_show_service_manager_notifications]&.values&.map(&:to_i)
          ))

    flash[:success] = "Your settings have been updated"
    redirect_to dealership_daily_checklist_config_index_path(@dealership)
  end

  private
    def daily_checklist_config_params
      params
        .require(:dealership_configuration)
        .permit(
            :include_check_for_test_drives_longer_than,
            :include_check_for_new_ucv_older_than,
            :include_check_for_used_ucv_older_than,
            :include_check_for_srv_loaner_older_than,
            sales_managers_custom_reminder_checklist_items: [],
            days_of_the_week_to_show_sales_manager_notifications: [],
            days_of_the_week_to_show_service_manager_notifications: []
          )
    end

end