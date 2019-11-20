module WebApi
  class EventsController < ApplicationController
    def index
      @test_drive_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "test_drive", acknowledged: :false).where(tags: {active: :true})
      @fuel_vehicle_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "fuel_vehicle", acknowledged: :false).where(tags: {active: :true})
      render json: {
                      test_drive_events: @test_drive_events.map{|e| EventSerializer.new(e).serialized_json},
                      fuel_vehicle_events: @fuel_vehicle_events.map{|e| EventSerializer.new(e).serialized_json},
                    }
    end
  end
end