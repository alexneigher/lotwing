module Api
  class ShapesController < ApplicationController
   
    def index
      @shapes = current_user.dealership.shapes.where.not(shape_type: 'parking_space').order(shape_type: :desc).all
      @parking_spaces = current_user.dealership.shapes.where(shape_type: 'parking_space')

      @full_parking_spaces =  @parking_spaces.joins(:vehicle)

      @empty_parking_spaces = @parking_spaces - @full_parking_spaces

      render json: @shapes.group_by(&:shape_type).merge(full_parking_space: @full_parking_spaces, empty_parking_space: @empty_parking_spaces)
    end

    def show
      @shape = current_user.dealership.shapes.find(params[:id])
      render json: { shape: @shape, tag: @shape.current_vehicle_tag, vehicle: @shape.vehicle }
    end
  end
end