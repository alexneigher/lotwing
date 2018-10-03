module Events
  class ResolutionsController < ApplicationController
    
    def new
      @event = current_user.dealership.events.find(params[:event_id])
    end

    def create
      
      @event = current_user.dealership.events.find(params[:event_id])
      @resolution = @event.resolutions.create(resolution_params.merge(user_id: current_user.id))
      
      if params[:commit] == 'Save & Resolve'
        @event.update(acknowledged: true)
      end

      redirect_to vehicles_path
    end


    private
      def resolution_params
        params.require(:resolution).permit(:details)
      end
  end
end