module Api
  class ShapesController < Api::BaseController
    before_action :set_dealership
    before_action :set_parking_lot

    def index
      @shapes = @dealership.shapes.where(parking_lot: @current_parking_lot).where.not(shape_type: 'parking_space').order(shape_type: :desc).all
      @parking_spaces = @dealership.shapes.where(shape_type: 'parking_space', parking_lot: @current_parking_lot)

      render json: @shapes
                      .group_by{|s| s.shape_type.pluralize}
                      .merge(
                        parking_spaces: @parking_spaces,
                      )
    end

    def parking_lots
      @parking_lot = @dealership
                      .shapes
                      .where(
                        shape_type: 'parking_lot',
                        parking_lot: @current_parking_lot
                      )
      render json: {parking_lots: @parking_lot}
    end

    def buildings
      @building = @dealership.shapes
                      .where(
                        shape_type: 'building',
                        parking_lot: @current_parking_lot
                      )
      render json: {buildings: @building}
    end

    def landscaping
      @landscaping = @dealership.shapes
                      .where(
                        shape_type: 'landscaping',
                        parking_lot: @current_parking_lot
                      )
      render json: {landscaping: @landscaping}
    end

    def parking_spaces
      binding.pry
      @parking_spaces = @dealership
                          .shapes
                          .where(
                            shape_type: 'parking_space',
                            parking_lot: @current_parking_lot
                          )

      @new_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "is_new", sold_status: nil})
      @used_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "is_used", sold_status: nil})

      @loaner_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "loaner", sold_status: nil})
      @lease_return_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "lease_return", sold_status: nil})
      @wholesale_unit_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "wholesale_unit", sold_status: nil})

      @service_hold_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {service_hold: true}) #this is superimposed on all other "types"
      @sales_hold_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {sales_hold: true}) #this is superimposed on all other "types"
      @sold_vehicle_spaces = @parking_spaces.joins(:vehicle).where.not(vehicles: {sold_status: nil})

      @duplicate_shape_ids = @parking_spaces.includes(:tags).where(tags: {active: true}).select{|p| p.tags.length > 1}

      all_vehicle_spaces  = [@new_vehicle_occupied_space + @used_vehicle_occupied_space + @loaner_occupied_spaces + @lease_return_occupied_spaces +@wholesale_unit_occupied_spaces + @sold_vehicle_spaces + @service_hold_spaces + @sales_hold_spaces].flatten

      @empty_parking_space = @parking_spaces - all_vehicle_spaces

      render json: {
                    new_vehicle_occupied_spaces: @new_vehicle_occupied_space,
                    used_vehicle_occupied_spaces: @used_vehicle_occupied_space,
                    loaner_occupied_spaces: @loaner_occupied_spaces,
                    lease_return_occupied_spaces: @lease_return_occupied_spaces,
                    wholesale_unit_occupied_spaces: @wholesale_unit_occupied_spaces,
                    sold_vehicle_spaces: @sold_vehicle_spaces,
                    empty_parking_spaces: @empty_parking_space,
                    duplicate_parked_spaces: @duplicate_shape_ids,
                    service_hold_spaces: @service_hold_spaces,
                    sales_hold_spaces: @sales_hold_spaces
                  }
    end

    def show
      @shape = @dealership.shapes.find(params[:id])
      serialized_events = []
      @shape.vehicles.includes(:tags).where(tags: {active: true}).each do |vehicle|
        serialized_events << vehicle
                              &.events
                              &.order(created_at: :desc)
                              &.includes(tag: :shape)
                              &.map{|e| EventSerializer.new(e, includes:[:user]) }
      end

      render json: { shape: @shape, events: serialized_events, vehicles: @shape.vehicles.includes(:tags).where(tags: {active: true}) }
    end

    private

      def set_dealership
        @dealership = current_user.dealership
      end

      def set_parking_lot
        @current_parking_lot = (@dealership.parking_lots.find_by_name(params[:parking_lot_name]) || @dealership.primary_parking_lot)
      end
  end
end