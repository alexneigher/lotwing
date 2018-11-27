module WebApi
  class EventsController < ApplicationController
    def index
      @note_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "note", acknowledged: :false).where(tags: {active: :true})
      @test_drive_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "test_drive").where(tags: {active: :true})
      
      render json: {
                      note_events: @note_events.map{|e| EventSerializer.new(e).serialized_json},
                      test_drive_events: @test_drive_events.map{|e| EventSerializer.new(e).serialized_json},
                    }
    end
  end
end