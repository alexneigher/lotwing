module Api
  class ShapesController < ApplicationController
   
    def index
      @shapes = current_user.dealership.shapes.order(shape_type: :desc).all
      render json: @shapes.group_by(&:shape_type)
    end

    def show
      @shape = current_user.dealership.shapes.find(params[:id])
      render json: { shape: @shape, tag: @shape.current_vehicle_tag, vehicle: @shape.vehicle }
    end
  end
end