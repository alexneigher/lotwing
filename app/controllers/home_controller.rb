class HomeController < ApplicationController

  def show
    dealership = current_user.dealership
    @grouped_shapes = dealership.shapes.group(:shape_type).count
    @vehicles = dealership.vehicles.includes(:current_parking_tag)
    @user_events = Event.includes(:user, {tag: :vehicle}).where(user_id: current_user.dealership.users.pluck(:id)).where(tags: {active: true})
  end

  def map_builder
    @shapes = Shape.all
  end
end