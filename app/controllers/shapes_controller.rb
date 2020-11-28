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
          shape_type: params[:shape][:shape_type].to_i,
          parking_lot_id: params[:shape][:parking_lot_id].to_i
        )
      end
    end

    redirect_to map_builder_path
  end

  def update
    shape = current_user.dealership.shapes.find(params[:id])

    shape.update(shape_params)

    redirect_to map_builder_path
  end


  def destroy
    @shape = current_user.dealership.shapes.find(params[:id])
    @shape.destroy

    redirect_to map_builder_path
  end

  private
    def shape_params
      params.require(:shape).permit(:temporary)
    end

end