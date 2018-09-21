module Api
  class ShapesController < ApplicationController
   
    def index
      @shapes = current_user.dealership.shapes.where.not(shape_type: 'parking_space').order(shape_type: :desc).all
      @parking_spaces = current_user.dealership.shapes.where(shape_type: 'parking_space')

      render json: @shapes
                      .group_by{|s| s.shape_type.pluralize}
                      .merge(
                              parking_spaces: @parking_spaces,
                            )
    end

    def parking_lots
      @parking_lot = current_user.dealership.shapes.where(shape_type: 'parking_lot')
      render json: {parking_lots: @parking_lot}
    end

    def buildings
      @building = current_user.dealership.shapes.where(shape_type: 'building')
      render json: {buildings: @building}
    end

    def parking_spaces
      @parking_spaces = current_user.dealership.shapes.where(shape_type: 'parking_space')

      @new_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {is_used: false})

      @used_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {is_used: true})
      
      @empty_parking_space = @parking_spaces - [@new_vehicle_occupied_space + @used_vehicle_occupied_space].flatten

      render json: {
                    new_vehicle_occupied_spaces: @new_vehicle_occupied_space,
                    used_vehicle_occupied_spaces: @used_vehicle_occupied_space,
                    empty_parking_spaces: @empty_parking_space
                   }
    end

    def show
      @shape = current_user.dealership.shapes.find(params[:id])

      serialized_events = @shape.current_vehicle_tag&.events&.includes(tag: :shape)&.map{|e| EventSerializer.new(e, includes:[:user]) }
      render json: { shape: @shape, events: serialized_events, vehicle: @shape.vehicle }
    end
  end
end