class TagsController < ApplicationController

  def create
    @tag = Tag.create(tag_params)
    
    #this should deactivate the other tag associated w/ this vehicle and space

    redirect_to root_path
  end

  def deactivate
    @tag = Tag.find(params[:tag_id])
    @tag.update(active: false)

    redirect_to root_path
  end

  private
    def tag_params
      params.require(:tag).permit(:vehicle_id, :shape_id)
    end
end