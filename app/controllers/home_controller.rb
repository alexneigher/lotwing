class HomeController < ApplicationController

  def show
    dealership = current_user.dealership
    @grouped_shapes = dealership.shapes.group(:shape_type).count
    @vehicles = dealership.vehicles.includes(:current_parking_tag)
  end

  def map_builder
    @shapes = Shape.all
  end
end