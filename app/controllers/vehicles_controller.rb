class VehiclesController < ApplicationController
  
  def index    
    @dealership = current_user.dealership
    all_vehicles = @dealership.vehicles.includes(:current_parking_tag, :open_service_tickets, :events)
    filtered_vehicles = all_vehicles

    if params.dig(:filter, :model).present?
      filtered_vehicles = all_vehicles.where(usage_type: "is_new").where(model: params[:filter][:model])
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        filtered_vehicles = filtered_vehicles.order(k => v)
      end
    end

    if params.dig(:filter, :usage_type).present?
      filtered_vehicles = filtered_vehicles.where(usage_type: params.dig(:filter, :usage_type))
    end

    filtered_vehicles = maybe_filter_by_no_tags(all_vehicles)

    @filtered_vehicles = filtered_vehicles || all_vehicles
    @all_vehicles = all_vehicles
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    @vehicle.update(vehicle_params)

    VehicleHoldUpdaterService.new(@vehicle, vehicle_params, current_user).maybe_update_holds

    redirect_to vehicle_path(@vehicle)
  end

  def show
    @vehicle = Vehicle.find(params[:id])
    
    @events = @vehicle.events.includes(:user, :resolutions)

    @dealership = current_user.dealership
    all_vehicles = @dealership.vehicles.includes(:current_parking_tag, :open_service_tickets)
    filtered_vehicles = all_vehicles

    if params.dig(:filter, :model).present?
      filtered_vehicles = all_vehicles.where(usage_type: "is_new").where(model: params[:filter][:model])
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        filtered_vehicles = filtered_vehicles.order(k => v)
      end
    end

    if params.dig(:filter, :usage_type).present?
      filtered_vehicles = filtered_vehicles.where(usage_type: params.dig(:filter, :usage_type))
    end

    filtered_vehicles = maybe_filter_by_no_tags(all_vehicles)

    @filtered_vehicles = filtered_vehicles || all_vehicles
    @all_vehicles = all_vehicles
  end

  #used to toggle the map modal only
  def show_map
    @vehicle = Vehicle.find(params[:vehicle_id])
    @events = @vehicle.events.includes(:user, :resolutions)
    dealership = current_user.dealership
  end

  def new
  end

  def create
    Vehicle.user_created.create(vehicle_params)
    redirect_to vehicles_path
  end

  def search
    @dealership = current_user.dealership
    @vehicles = @dealership.vehicles.includes(:current_parking_tag, :open_service_tickets).where('stock_number ilike ?', "%#{params[:stock_number]}%")


    @all_vehicles = @dealership.vehicles.includes(:current_parking_tag, :open_service_tickets)

    maybe_filter_by_no_tags(@all_vehicles)

    @filtered_vehicles = @vehicles

    

    render :index
  end

  def destroy
    @dealership = current_user.dealership
    vehicle = @dealership.vehicles.find(params[:id])
    vehicle.destroy

    redirect_to vehicles_path
  end


  def print_hold_tag
    @vehicle = Vehicle.find(params[:vehicle_id])
    respond_to do |format|
     format.pdf do
       render pdf: "Hold Tag - #{@vehicle.stock_number}",
       template: "vehicles/hold_tag.html.haml",
       orientation: "Landscape",
       layout: 'pdf.html.erb'
     end
    end
  end

  def print_service_hold_tag
    @vehicle = Vehicle.find(params[:vehicle_id])
    respond_to do |format|
     format.pdf do
       render pdf: "Hold Tag - #{@vehicle.stock_number}",
       template: "vehicles/service_hold_tag.html.haml",
       orientation: "Landscape",
       layout: 'pdf.html.erb'
     end
    end
  end

  private
    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :year, :vin, :color, :dealership_id, :usage_type, :sales_hold, :service_hold, :sales_hold_notes, :service_hold_notes, :stock_number )
    end

    def maybe_filter_by_no_tags(all_vehicles)
      #do no tag stuff here
      currently_parked_vehicle_ids = @dealership.shapes.where(shape_type: 'parking_space').joins(:vehicle).pluck(:vehicle_id)
      @vehicles_missing_tags = (all_vehicles || []).reject{|v| v.id.in?(currently_parked_vehicle_ids) }
      
      if params.dig(:filter, :no_tag).present?
        filtered_vehicles = @vehicles_missing_tags
      end

      return filtered_vehicles
    end
end
