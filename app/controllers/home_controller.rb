class HomeController < ApplicationController

  def show
    dealership = current_user.dealership
    @grouped_shapes = dealership.shapes.group(:shape_type).count
    @vehicles = dealership.vehicles.all #n+1 fixme
  end

  def map_builder
    @shapes = Shape.all
  end
end