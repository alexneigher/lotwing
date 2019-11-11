class VehicleHoldUpdaterService

  def initialize(vehicle, params, user)
    @vehicle = vehicle
    @params = params
    @user = user  
  end

  def maybe_update_holds
    update_sales_hold if @params[:sales_hold] == "1"
    update_service_hold if @params[:service_hold] == "1"
  end

  private
    def update_sales_hold
      @vehicle.update(sales_hold_creator: @user.full_name, sales_hold_created_at: DateTime.now)
    end

    def update_service_hold
      @vehicle.update(service_hold_creator: @user.full_name, service_hold_created_at: DateTime.now)
    end
end