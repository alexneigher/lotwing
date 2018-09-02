module Api
  class ShapesController < ApplicationController
   
    def index
      @shapes = current_user.dealership.shapes.order(shape_type: :desc).all
      render json: @shapes.group_by(&:shape_type)
    end
  end
end