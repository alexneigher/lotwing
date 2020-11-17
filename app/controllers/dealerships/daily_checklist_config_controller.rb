class Dealerships::DailyChecklistConfigController < ApplicationController

  def index
    @dealership = current_user.dealership
  end

  def update
    @dealership = current_user.dealership
    @dealership.dealership_configuration.update(daily_checklist_config_params)

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
            service_managers_custom_reminder_checklist_items: [],
            sales_managers_custom_reminder_checklist_items: []
          )
    end

end