class EventsController < ApplicationController

  def show
    @event = current_user.dealership.events.find(params[:id])
  end
end