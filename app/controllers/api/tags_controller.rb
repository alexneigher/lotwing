module Api
  class TagsController < Api::BaseController
    def create
      @vehicle = Vehicle.find(params[:tag][:vehicle_id])

      if @vehicle.is_currently_on_test_drive?
        render json: {status: 403, error: "This vehicle is currently on a test drive"} and return
      end

      # before doing anything with the new event, check if it should be a change stall or a tag (if one of those type)
      # tag is when they are the same
      # change stall is when the new shape_id is different from the current shape id
      true_event_type = event_params[:event_type]
      event_details = params[:event][:event_details]

      if event_params[:event_type] == "change_stall" || event_params[:event_type] == 'tag'
        if @vehicle.parking_space&.id&.to_s == tag_params[:shape_id]
          # if the vehicle has been tagged in the same parking space, make sure this is just a tag event
          true_event_type = 'tag'
          event_details = "Tagged vehicle in stall #{@vehicle.parking_space&.id}"
        else
          # if it is different (or if the current parking space is unknown)
          # this is a change stall
          true_event_type = "change_stall"
        end

      end

      @vehicle.tags.update_all(active: false)

      #if we are starting a test_drive or a fuel_vehicle, create an inactive tag which will remove it from the lot
      if event_params[:event_type] == 'test_drive' || event_params[:event_type] == 'fuel_vehicle'
        maybe_active_tag = { active: false }
      else
        maybe_active_tag = { active: true }
      end

      @tag = Tag.create(tag_params.merge(maybe_active_tag))

      #move all of the note events to the new tag to persist them on map
      @vehicle.events.where(event_type: "note").update_all(tag_id: @tag.id)

      # track the recency of movement
      @tag.shape.update(most_recently_tagged_at: DateTime.current)

      # create a new event
      event = @tag.events.create(event_params.merge(user_id: current_user.id, event_type: true_event_type, event_details: event_details))


      # do event type specific stuff
      if event.event_type == "odometer_update"
        @vehicle.update(mileage: event.event_details)
      end

      render json: {status: 200, parking_space: @tag.shape, vehicle: @vehicle, event: event}
    end


    private
      def tag_params
        params.require(:tag).permit(:vehicle_id, :shape_id)
      end

      def event_params
        params.require(:event).permit(:event_type, :event_details, :started_at, :ended_at)
      end
  end
end