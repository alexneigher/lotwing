class DealershipsController < ApplicationController
  
  def update
    @dealership = current_user.dealership
    @dealership.update(dealership_params)
    redirect_to map_builder_path
  end

  private
    def dealership_params
      params.require(:dealership).permit(:map_bearing, :map_zoom)
    end
end
