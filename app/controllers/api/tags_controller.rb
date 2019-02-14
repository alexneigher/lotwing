module Api
  class TagsController < Api::BaseController
    def create
      @vehicle = Vehicle.find(params[:tag][:vehicle_id])
      @vehicle.tags.update_all(active: false)
      
      @tag = Tag.create(tag_params)

      #move all of the note events to the new tag to persist them on map
      @vehicle.events.where(event_type: "note").update_all(tag_id: @tag.id)

      # track the recency of movement
      @tag.shape.update(most_recently_tagged_at: DateTime.current)

      # create a new event
      @tag.events.create(event_params.merge(user_id: current_user.id))

      render json: {status: 200, parking_space: @tag.shape, vehicle: @vehicle}
    end


    private
      def tag_params
        params.require(:tag).permit(:vehicle_id, :shape_id)
      end

      def event_params
        params.require(:event).permit(:event_type, :event_details)
      end
  end
end