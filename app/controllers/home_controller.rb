class HomeController < ApplicationController

  def show
    dealership = current_user.dealership
    
    @events_from_24h = current_user.dealership.events.includes(:user).where(events: {created_at: [24.hours.ago..DateTime.current]})
    
    @events_from_today = current_user.dealership.events.includes(:user).where(events: {created_at: [DateTime.current.in_time_zone("Pacific Time (US & Canada)").beginning_of_day..DateTime.current]})
    
    @vehicles_off_lot = current_user.dealership.vehicles.joins(:events).where.not(events: {started_at: nil}).where(events: {ended_at: nil}).where(events: {event_type: ["test_drive", "fuel_vehicle"]})
    
    @vehicles_with_sales_holds = current_user.dealership.vehicles.where(sales_hold: true)

    @vehicles_with_service_holds =  current_user.dealership.vehicles.where(service_hold: true)
  end

  def map_builder
    @shapes = current_user.dealership.shapes.order(:id).all
  end
end