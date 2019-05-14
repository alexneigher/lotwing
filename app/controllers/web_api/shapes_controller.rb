module WebApi
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
      
      new_vehicle_space_ids = @new_vehicle_occupied_space.pluck(:id).detect{ |e| @new_vehicle_occupied_space.pluck(:id).count(e) > 1 }
      used_vehicle_space_ids = @used_vehicle_occupied_space.pluck(:id).detect{ |e| @used_vehicle_occupied_space.pluck(:id).count(e) > 1 }

      @empty_parking_space = @parking_spaces - [@new_vehicle_occupied_space + @used_vehicle_occupied_space].flatten

      render json: {
                    new_vehicle_occupied_spaces: @new_vehicle_occupied_space,
                    used_vehicle_occupied_spaces: @used_vehicle_occupied_space,
                    empty_parking_spaces: @empty_parking_space,
                    duplicate_parked_spaces: Shape.where(id: [new_vehicle_space_ids , used_vehicle_space_ids].flatten)
                   }
    end

    def show
      @shape = current_user.dealership.shapes.find(params[:id])
      serialized_events = []
      @shape.vehicles.includes(:tags).where(tags: {active: true}).each do |vehicle|
        serialized_events << vehicle
                              &.events
                              &.includes(tag: :shape)
                              &.where(acknowledged: false)
                              &.map{|e| EventSerializer.new(e, includes:[:user]) }
      end
      
      render json: { shape: @shape, events: serialized_events, vehicles: @shape.vehicles.includes(:tags).where(tags: {active: true}) }
    end
  end
end