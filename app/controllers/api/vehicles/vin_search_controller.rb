module Api
  module Vehicles
    class VinSearchController < Api::BaseController

      # GET /api/vehicles/vin_search/:vin
      # return a vehicle based on vin

      def show
        @vehicle = current_user.dealership.vehicles.find_by_vin(params[:vin])
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