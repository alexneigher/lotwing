class TagsController < ApplicationController

  def create
    @vehicle = Vehicle.find(params[:tag][:vehicle_id])
    @vehicle.tags.update_all(active: false)
    
    @tag = Tag.create(tag_params)

    redirect_to vehicle_manager_path
  end

  def deactivate
    @tag = Tag.find(params[:tag_id])
    @tag.update(active: false)

    redirect_to vehicle_manager_path
  end

  private
    def tag_params
      params.require(:tag).permit(:vehicle_id, :shape_id)
    end
end