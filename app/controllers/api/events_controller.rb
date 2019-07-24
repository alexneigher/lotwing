module Api
  class EventsController < Api::BaseController
    before_action :set_event, only: [:show, :update, :destroy]

    # GET /api/events/:id
    def show
      json_response(@event)
    end

    # PUT /api/events/:id
    def update
      event = @event.update(event_params)
      
      json_response(event)
      head :no_content
    end


    def index
      @note_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "note", acknowledged: :false).where(tags: {active: :true})
      @test_drive_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "test_drive", acknowledged: :false).where(tags: {active: :true})
      @fuel_vehicle_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "fuel_vehicle", acknowledged: :false).where(tags: {active: :true})
      render json: {
                    note_events: @note_events.map{|e| EventSerializer.new(e)},
                    test_drive_events: @test_drive_events.map{|e| EventSerializer.new(e)},
                    fuel_vehicle_events: @fuel_vehicle_events.map{|e| EventSerializer.new(e)},
                  }
    end

    private

    def event_params
      # whitelist params
      params.permit(:acknowledged, :event_type, :event_details, :started_at, :ended_at)
    end

    def set_event
      @event = current_user.dealership.events.find(params[:id])
    end
  end
end