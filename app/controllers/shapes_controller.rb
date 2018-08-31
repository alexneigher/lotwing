class ShapesController < ApplicationController


  def create
    geo_info = JSON.parse(params[:shape][:geo_info])

    Shape.create!(geo_info: geo_info)

    redirect_to map_builder_path
  end

  def destroy
    @shape = Shape.find(params[:id])
    @shape.destroy

    redirect_to map_builder_path
  end

  private
    def shape_params
      params.require(:shape).permit(:geo_info)
    end

end