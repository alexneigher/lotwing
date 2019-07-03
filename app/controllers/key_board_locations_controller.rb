class KeyBoardLocationsController < ApplicationController
  
  def create
    @dealership = current_user.dealership
    @dealership.key_board_locations.create(key_board_location_params)
    
    redirect_to edit_dealership_path(@dealership)
  end

  def edit
    @dealership = current_user.dealership
    @key_board_location = @dealership.key_board_locations.find(params[:id])
  end

  def update
    @dealership = current_user.dealership
    @key_board_location = @dealership.key_board_locations.find(params[:id])
    
    @key_board_location.update(key_board_location_params)

    redirect_to edit_dealership_path(@dealership) 
  end


  private
    def key_board_location_params
      params.require(:key_board_location).permit(:name)
    end
end