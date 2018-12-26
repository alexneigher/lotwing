class ShapesController < ApplicationController


  def create
    geo_info = JSON.parse(params[:shape][:geo_info])
    
    if params[:shape][:shape_type] == '0' #parking space
      ParkingSpaceBuilder.new(params, current_user.dealership_id).perform
    else
      geo_info.each do |geo|
        Shape.create!( 
          dealership_id: current_user.dealership.id,
          geo_info: geo, 
          shape_type: params[:shape][:shape_type].to_i
        )
      end
    end
    

    
    redirect_to map_builder_path
  end

  def destroy
    @shape = Shape.find(params[:id])
    @shape.destroy

    redirect_to map_builder_path
  end

end