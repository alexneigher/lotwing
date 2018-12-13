class HomeController < ApplicationController

  def show
    
  end

  def map_builder
    @shapes = Shape.all
  end
end