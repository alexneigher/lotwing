class VehiclesController < ApplicationController
  
  def index
    dealership = current_user.dealership

    @grouped_shapes = dealership.shapes.group(:shape_type).count
    @vehicles = dealership.vehicles.includes(:current_parking_tag)
  end

  def show
    @vehicle = Vehicle.find(params[:id])
  end

  def new
  end

  def create
    Vehicle.create(vehicle_params)
    redirect_to vehicles_path
  end

  def search
    #TODO
  end


  private
    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :year, :vin, :dealership_id, :is_used )
    end
end
