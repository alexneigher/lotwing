class VehiclesController < ApplicationController
  
  def index
    @vehicles = current_user.dealership.vehicles
  end

  def new
  end

  def vin_search
    @vehicles = Vehicle.where("vin ILIKE ?", "%#{params[:vin_search]}%")
    @shape_id = params[:shape_id]
  end

  def create
    Vehicle.create(vehicle_params)
    redirect_to vehicles_path
  end



  private
    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :year, :vin, :dealership_id )
    end
end
