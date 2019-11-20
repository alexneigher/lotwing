module WebApi
  class EventsController < ApplicationController
    def index
      @test_drive_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "test_drive", acknowledged: :false).where(tags: {active: :true})
      @fuel_vehicle_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "fuel_vehicle", acknowledged: :false).where(tags: {active: :true})
      render json: {
                      note_events: note_events,
                      test_drive_events: @test_drive_events.map{|e| EventSerializer.new(e).serialized_json},
                      fuel_vehicle_events: @fuel_vehicle_events.map{|e| EventSerializer.new(e).serialized_json},
                    }
    end

    def note_events
      return [] if params[:display_mode] == "hold_vehicles"
      
      @note_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "note", acknowledged: :false).where(tags: {active: :true})

      return @note_events.map{|e| EventSerializer.new(e).serialized_json}
    end
  end
end