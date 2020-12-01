module Api
  class ParkingLotsController < Api::BaseController

    def index
      all_lots = current_user.dealership.parking_lots

      render json: {parking_lots: all_lots}
    end

  end
end