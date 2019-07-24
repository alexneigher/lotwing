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
        events = @vehicle
                    &.events
                    &.order(created_at: :desc)
                    &.includes(tag: :shape)
                    &.where(acknowledged: false)
                    &.map{|e| EventSerializer.new(e, includes:[:user]) }
                    
        render json: { vehicle: @vehicle, current_parking_space: @vehicle&.parking_space, events: events}

      end

    end
  end
end