class VehiclesController < ApplicationController

  def index
    @dealership = current_user.dealership
    @vehicles = @dealership.vehicles.includes(:current_parking_tag, :open_service_tickets)

    if params.dig(:stock_number).present?
      @vehicles = @vehicles.where('stock_number ilike ?', "%#{params[:stock_number]}%")
    end

    if params.dig(:filter, :usage_type).present?
      @vehicles = @vehicles.where(usage_type: params.dig(:filter, :usage_type))
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        @vehicles = @vehicles.order(k => v)
      end
    end

    #model filters should only ever show new vehicles
    if params.dig(:filter, :model).present?
      @vehicles = @vehicles.where(usage_type: 'is_new', model: params.dig(:filter, :model))
    end

    if params.dig(:filter, :no_tag).present?
      @vehicles = Vehicle.where(id: vehicles_missing_tags(@dealership, @vehicles).pluck(:id))

    end

    @vehicles = @vehicles.page(params[:page]).per(50)
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    @vehicle.update(vehicle_params)
    @events = @vehicle.events.includes(:user, :resolutions) #needed to re-render
    flash.now[:success] = 'Vehicle update saved'
    VehicleHoldUpdaterService.new(@vehicle, vehicle_params, current_user).maybe_update_holds

  end

  def show
    @vehicle = Vehicle.find(params[:id])
    @events = @vehicle.events.includes(:user, :resolutions)
  end

  def show_info_modal
    @vehicle = current_user.dealership.vehicles.includes(:tags).find(params[:vehicle_id])
    @events = @vehicle.events.includes(:user, :resolutions)
    @context = "lot_view"
  end


  #used to toggle the map modal only
  def show_map
    @vehicle = Vehicle.find(params[:vehicle_id])
    @events = @vehicle.events.includes(:user, :resolutions)
    dealership = current_user.dealership

    @vehicle_color = @vehicle.map_color
  end

  def new
  end

  # route used by ajax request to populate colored pills
  def inventory_count
    dealership = current_user.dealership
    vehicles = dealership.vehicles

    @grouped_vehicles = vehicles.group(:usage_type).count

    @vehicles_missing_tags_length = vehicles_missing_tags(dealership, vehicles).length

  end

  # route used by right side of VM page to render grouped new vehicles
  def new_vehicle_groupings
    dealership = current_user.dealership
    @vehicles = dealership.vehicles.where(usage_type: "is_new").group_by(&:model).sort_by{ |key| key }.to_h
  end


  def create
    Vehicle.user_created.create(vehicle_params)

    Event.create(event_type: :create_vehicle, user: current_user, event_details: vehicle_params.to_unsafe_h)

    redirect_to vehicles_path
  end

  def destroy
    @dealership = current_user.dealership
    vehicle = @dealership.vehicles.find(params[:id])
    vehicle.destroy

    #when triggering delete from a filtered lot view, sometimes there will be a display mode
    if params[:display_mode].present?
      redirect_to lot_view_path(display_mode: params[:display_mode])
    else
      redirect_to vehicles_path
    end
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

    def vehicles_missing_tags(dealership, vehicles)
      currently_parked_vehicle_ids = dealership.shapes.where(shape_type: 'parking_space').joins(:vehicle).pluck(:vehicle_id)
      active_test_drive_vehicle_ids = dealership.events.where(event_type: 'test_drive', ended_at: nil).includes(:tag).pluck(:vehicle_id)

      all_vehicles_not_on_test_drives = vehicles.reject{|v| v.id.in?(active_test_drive_vehicle_ids) }

      vehicles_missing_tags = (all_vehicles_not_on_test_drives || []).reject{|v| v.id.in?(currently_parked_vehicle_ids)}
    end

end
