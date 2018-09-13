class VehiclesController < ApplicationController
  
  def index
    dealership = current_user.dealership

    @grouped_shapes = dealership.shapes.group(:shape_type).count
    @vehicles = dealership.vehicles.includes(:current_parking_tag)
  end

  def new
  end

  def vin_search
    @vehicles = Vehicle
                  .where("vin ILIKE ?", "%#{params[:vin_search]}%")

    @shape_id = params[:shape_id]
  end

  def create
    Vehicle.create(vehicle_params)
    redirect_to vehicles_path
  end


  private
    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :year, :vin, :dealership_id, :is_used )
    end
end
