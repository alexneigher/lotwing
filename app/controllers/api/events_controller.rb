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

    private

    def event_params
      # whitelist params
      params.permit(:acknowledged, :event_type, :event_details)
    end

    def set_event
      @event = current_user.dealership.events.find(params[:id])
    end
  end
end