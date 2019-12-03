module Api
  class ActiveDrivesController < Api::BaseController
    
    def show
      open_events = current_user.events.joins(tag: :vehicle).where.not(started_at: nil).where(ended_at: nil)
      
      data = []
      open_events.each do |event|
        data << {event: event, vehicle: event.tag&.vehicle}
      end
      
      render json: {data: data}
    end

  end
end