class DealershipsController < ApplicationController
  
  def edit
    @dealership = current_user.dealership
  end

  def update
    @dealership = current_user.dealership
    @dealership.update(dealership_params)
    redirect_to root_path
  end

  private
    def dealership_params
      params.require(:dealership).permit(:map_bearing, :map_zoom, :custom_mtd_start_date, :name)
    end
end
