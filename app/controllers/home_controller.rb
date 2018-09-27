class HomeController < ApplicationController

  def show
    dealership = current_user.dealership
    @users_with_events = current_user.dealership.users.includes(events: :tag).where(tags: {active: true})
  end

  def map_builder
    @shapes = Shape.all
  end
end