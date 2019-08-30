module Api
  class VehiclesController < Api::BaseController
    before_action :set_vehicle, only: [:show, :update, :destroy]

    # GET /api/vehicles
    def index
      @vehicles = current_user.dealership.vehicles.all
      json_response(@vehicles)
    end

    # POST /api/vehicles
    def create
      @vehicle = current_user.dealership.vehicles.user_created.create!(vehicle_params)
      json_response(@vehicle, :created)
    end

    # GET /api/vehicles/:id
    def show
      json_response(@vehicle)
    end

    # PUT /api/vehicles/:id
    def update
      @vehicle.update(vehicle_params)
      head :no_content
    end

    # DELETE /api/vehicles/:id
    def destroy
      @vehicle.destroy
      head :no_content
    end

    private

    def vehicle_params
      # whitelist params
      params.permit(:title, :make, :model, :year, :stock_number, :vin, :mileage, :creation_source, :key_board_location_name, :usage_type)
    end

    def set_vehicle
      @vehicle = current_user.dealership.vehicles.find(params[:id])
    end
  end
end