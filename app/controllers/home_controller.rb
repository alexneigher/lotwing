class HomeController < ApplicationController

  def show
    dealership = current_user.dealership
    @users_with_events = current_user.dealership.users.includes(events: :tag).where(events: {created_at: [24.hours.ago..DateTime.current]})
  end

  def map_builder
    @shapes = current_user.dealership.shapes.order(:id).all
  end
end