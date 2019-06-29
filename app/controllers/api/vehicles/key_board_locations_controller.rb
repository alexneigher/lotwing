module Api
  class KeyboardLocationsController < Api::BaseController

    # GET /api/key_board_locations
    def index
      @key_board_locations = current_user.dealership.key_board_locations.all

      json_response(@key_board_locations)
    end

    # GET /api/key_board_locations/:id
    def show
      @key_board_locations = current_user.dealership.key_board_locations.find[params[:id]]
      json_response(@key_board_location)
    end
  end
end