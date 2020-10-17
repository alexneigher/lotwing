class HomeController < ApplicationController

  def show
    dealership = current_user.dealership

    @events_from_24h = current_user.dealership.events.includes(:user).where(events: {created_at: [24.hours.ago..DateTime.current]})

    @events_from_today = current_user.dealership.events.includes(:user).where(events: {created_at: [DateTime.current.in_time_zone("Pacific Time (US & Canada)").beginning_of_day..DateTime.current]})

    @vehicles_off_lot = current_user.dealership.vehicles.joins(:events).where.not(events: {started_at: nil}).where(events: {ended_at: nil}).where(events: {event_type: ["test_drive", "fuel_vehicle"]})

    @vehicles_with_sales_holds = current_user.dealership.vehicles.where(sales_hold: true)

    @vehicles_with_service_holds = current_user.dealership.vehicles.includes(service_tickets: :service_ticket_departments).where(service_hold: true)
  end

  def lot_view_info_bar
    dealership = current_user.dealership
    @parking_spaces = dealership.shapes.where(shape_type: 'parking_space', temporary: false)

    @new_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "is_new", sold_status: nil}).count
    @used_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "is_used", sold_status: nil}).count

    @loaner_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "loaner", sold_status: nil}).count
    @lease_return_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "lease_return", sold_status: nil}).count
    @wholesale_unit_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "wholesale_unit", sold_status: nil}).count

    all_vehicle_spaces = @new_vehicle_occupied_space + @used_vehicle_occupied_space + @loaner_occupied_spaces + @lease_return_occupied_spaces + @wholesale_unit_occupied_spaces

    @total_parking_spaces = @parking_spaces.count

    @empty_parking_spaces = @total_parking_spaces - all_vehicle_spaces
  end

  def map_builder
    @shapes = current_user.dealership.shapes.order(:id).all
  end
end