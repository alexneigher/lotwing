class DealershipsController < ApplicationController
  
  def edit
    redirect_to root_path and return if current_user.permission_level == "sales_rep"

    @dealership = current_user.dealership
  end

  def update
    @dealership = current_user.dealership
    @dealership.update(dealership_params)
    redirect_to root_path
  end

  private
    def dealership_params
      params.require(:dealership).permit(:map_bearing, :map_zoom, :custom_mtd_start_date, :new_note_notification_addresses, :new_service_ticket_notification_addresses, :name, data_sync_attributes: [ :id, :provider_id ])
    end
end
