module Api
  class ShapesController < ApplicationController
   
    def index
      @shapes = current_user.dealership.shapes.where.not(shape_type: 'parking_space').order(shape_type: :desc).all
      @parking_spaces = current_user.dealership.shapes.where(shape_type: 'parking_space')

      render json: @shapes
                      .group_by(&:shape_type)
                      .merge(
                              parking_space: @parking_spaces,
                            )
    end


    def vehicles_index
      #homepage index
      @shapes = current_user.dealership.shapes.where.not(shape_type: 'parking_space').order(shape_type: :desc).all
      @parking_spaces = current_user.dealership.shapes.where(shape_type: 'parking_space')

      @new_vehicle_occupied_space =  @parking_spaces.joins(:vehicle).where(vehicles: {is_used: false})
      @used_vehicle_occupied_space =  @parking_spaces.joins(:vehicle).where(vehicles: {is_used: true})
      
      @empty_parking_space = @parking_spaces - [@new_vehicle_occupied_space + @used_vehicle_occupied_space].flatten

      render json: @shapes
                      .group_by(&:shape_type)
                      .merge(

                              new_vehicle_occupied_space: @new_vehicle_occupied_space,
                              used_vehicle_occupied_space: @used_vehicle_occupied_space,
                              empty_parking_space: @empty_parking_space
                            )
    end

    def show
      @shape = current_user.dealership.shapes.find(params[:id])
      render json: { shape: @shape, tag: @shape.current_vehicle_tag, vehicle: @shape.vehicle }
    end
  end
end