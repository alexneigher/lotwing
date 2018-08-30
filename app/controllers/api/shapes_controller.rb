module Api
  class ShapesController < ApplicationController
   
    def index
      @shapes = Shape.all
      render json: @shapes
    end
  end
end