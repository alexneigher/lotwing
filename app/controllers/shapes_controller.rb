class ShapesController < ApplicationController


  def create
    geo_info = JSON.parse(params[:shape][:geo_info])

    Shape.create!( 
                  dealership_id: current_user.dealership.id,
                  geo_info: geo_info, 
                  shape_type: params[:shape][:shape_type].to_i 
                )

    redirect_to map_builder_path
  end

  def destroy
    @shape = Shape.find(params[:id])
    @shape.destroy

    redirect_to map_builder_path
  end

end