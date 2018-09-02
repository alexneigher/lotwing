module Api
  class ShapesController < ApplicationController
   
    def index
      @shapes = current_user.dealership.shapes.order(shape_type: :desc).all
      render json: @shapes
    end
  end
end