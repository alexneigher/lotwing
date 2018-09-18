module Api
  class EventsController < ApplicationController
    def index
      @events = current_user.dealership.events.includes(tag: :shape)
      render json: {events: @events.map{|e| EventSerializer.new(e).serialized_json}}
    end
  end
end