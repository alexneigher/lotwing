module Api
  module Vehicles
    class StockNumbersController < Api::BaseController

      # GET /api/vehicles/stock_numbers
      # return a collection of stock numbers for current dealership
      def index
        @stock_numbers = current_user.dealership.vehicles.pluck(:stock_number)
        json_response(@stock_numbers)
      end

      # GET /api/vehicles/stock_numbers/:stock_number
      # return a vehicle based on stock number

      def show
        @vehicle = current_user.dealership.vehicles.find_by_stock_number(params[:stock_number])
        render json: { vehicle: @vehicle, current_parking_space: @vehicle.parking_space}

      end

    end
  end
end