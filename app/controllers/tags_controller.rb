class TagsController < ApplicationController

  def create
    @vehicle = Vehicle.find(params[:tag][:vehicle_id])
    @vehicle.tags.update_all(active: false)
    
    @tag = Tag.create(tag_params)

    @tag.shape.update(most_recently_tagged_at: DateTime.current)

    @tag.events.create(event_params.merge(user_id: current_user.id))

    redirect_to vehicles_path
  end

  #temp UI for development work
  def new
  end

  def deactivate
    @tag = Tag.find(params[:tag_id])
    @tag.update(active: false)

    redirect_to vehicles_path
  end

  private
    def tag_params
      params.require(:tag).permit(:vehicle_id, :shape_id)
    end

    def event_params
      params.require(:event).permit(:event_type, :event_details)
    end
end