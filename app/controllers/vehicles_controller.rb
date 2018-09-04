class VehiclesController < ApplicationController
  def index
    @vehicles = current_user.dealership.vehicles
  end
end
