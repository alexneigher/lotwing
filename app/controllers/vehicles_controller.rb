class VehiclesController < ApplicationController
  
  def index
    dealership = current_user.dealership
    all_vehicles = dealership.vehicles.includes(:current_parking_tag, :service_tickets)
    filtered_vehicles = all_vehicles

    if params.dig(:filter).present?
      filtered_vehicles = all_vehicles.where(usage_type: "is_new").where(model: params[:filter][:model])
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        filtered_vehicles = filtered_vehicles.order(k => v)
      end
    end

    @filtered_vehicles = filtered_vehicles || all_vehicles
    @all_vehicles = all_vehicles
  end

  def show
    @vehicle = Vehicle.find(params[:id])
    dealership = current_user.dealership
    vehicles = dealership.vehicles.includes(:current_parking_tag)
    
    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        vehicles = vehicles.order(k => v)
      end
    end

    @vehicles = vehicles
  end

  #used to toggle the map modal only
  def show_map
    @vehicle = Vehicle.find(params[:vehicle_id])
    dealership = current_user.dealership
  end

  def new
  end

  def create
    Vehicle.user_created.create(vehicle_params)
    redirect_to vehicles_path
  end

  def search
    dealership = current_user.dealership
    @vehicles = dealership.vehicles.includes(:current_parking_tag).where('stock_number ilike ?', "%#{params[:stock_number]}%")

    @filtered_vehicles = @vehicles
    @all_vehicles = dealership.vehicles.includes(:current_parking_tag)

    render :index
  end

  def destroy
    dealership = current_user.dealership
    vehicle = dealership.vehicles.find(params[:id])
    vehicle.destroy

    redirect_to vehicles_path
  end


  private
    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :year, :vin, :dealership_id, :usage_type )
    end
end
