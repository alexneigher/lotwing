class HomeController < ApplicationController

  def show
    dealership = current_user.dealership
    users_with_24h_events = current_user.dealership.users.includes(events: :tag).where(events: {created_at: [24.hours.ago..DateTime.current]})
    users_with_today_events = current_user.dealership.users.includes(events: :tag).where(events: {created_at: [DateTime.current.in_time_zone("Pacific Time (US & Canada)").beginning_of_day..DateTime.current]})
    @vehicles_off_lot = current_user.dealership.vehicles.joins(:events).where.not(events: {started_at: nil}).where(events: {ended_at: nil}).where(events: {event_type: ["test_drive", "fuel_vehicle"]})
    
    @users_with_24h_events = users_with_24h_events.sort{|a, b| b.events.length <=> a.events.length}
    @users_with_today_events = users_with_today_events.sort{|a, b| b.events.length <=> a.events.length}

  end

  def map_builder
    @shapes = current_user.dealership.shapes.order(:id).all
  end
end