class DealershipsController < ApplicationController

  def edit
    redirect_to root_path and return if current_user.permission_level == "sales_rep"

    @dealership = current_user.dealership
    @dealership_users = @dealership.users.joins(:email_preference)
  end

  def update
    @dealership = current_user.dealership
    @dealership.update(dealership_params)
    redirect_to root_path
  end

  private
    def dealership_params
      params.require(:dealership).permit(:map_bearing, :map_zoom, :custom_mtd_start_date, :name, data_sync_attributes: [ :id, :provider_id ])
    end
end
