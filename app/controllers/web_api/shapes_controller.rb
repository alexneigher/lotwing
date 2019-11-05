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

      @new_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "is_new", sold_status: nil})
      @used_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "is_used", sold_status: nil})
      
      @loaner_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "loaner", sold_status: nil})
      @lease_return_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "lease_return", sold_status: nil})
      @wholesale_unit_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "wholesale_unit", sold_status: nil})

      @service_hold_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {service_hold: true})

      @sold_vehicle_spaces = @parking_spaces.joins(:vehicle).where.not(vehicles: {sold_status: nil})

      @duplicate_shape_ids = @parking_spaces.includes(:tags).where(tags: {active: true}).select{|p| p.tags.length > 1}

      maybe_filter_by_older_than_4_days
      maybe_filter_by_holds
      maybe_filter_by_no_test_drives

      all_vehicle_spaces  = [@new_vehicle_occupied_space + @used_vehicle_occupied_space + @loaner_occupied_spaces + @lease_return_occupied_spaces +@wholesale_unit_occupied_spaces + @sold_vehicle_spaces].flatten
      
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
                    service_hold_spaces: @service_hold_spaces 
                   }
    end

    def show
      @shape = current_user.dealership.shapes.find(params[:id])
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
      def maybe_filter_by_older_than_4_days
        return unless params.dig(:display_mode) == "no_tag_4_days"
        @new_vehicle_occupied_space = @new_vehicle_occupied_space.where('shapes.most_recently_tagged_at < ?', 4.days.ago)
        @used_vehicle_occupied_space = @used_vehicle_occupied_space.where('shapes.most_recently_tagged_at < ?', 4.days.ago)
        @loaner_occupied_spaces = @loaner_occupied_spaces.where('shapes.most_recently_tagged_at < ?', 4.days.ago)
        @lease_return_occupied_spaces = @lease_return_occupied_spaces.where('shapes.most_recently_tagged_at < ?', 4.days.ago)
        @wholesale_unit_occupied_spaces = @wholesale_unit_occupied_spaces.where('shapes.most_recently_tagged_at < ?', 4.days.ago)
        @sold_vehicle_spaces = @sold_vehicle_spaces.where('shapes.most_recently_tagged_at < ?', 4.days.ago)
        @duplicate_shape_ids = @parking_spaces.includes(:tags).where('shapes.most_recently_tagged_at < ?', 4.days.ago).where(tags: {active: true}).select{|p| p.tags.length > 1}
      end

      def maybe_filter_by_holds
        return unless params.dig(:display_mode) == "hold_vehicles"
        @new_vehicle_occupied_space = @new_vehicle_occupied_space.where("vehicles.sales_hold is true OR vehicles.service_hold is true")
        @used_vehicle_occupied_space = @used_vehicle_occupied_space.where("vehicles.sales_hold is true OR vehicles.service_hold is true")
        @loaner_occupied_spaces = @loaner_occupied_spaces.where("vehicles.sales_hold is true OR vehicles.service_hold is true")
        @lease_return_occupied_spaces = @lease_return_occupied_spaces.where("vehicles.sales_hold is true OR vehicles.service_hold is true")
        @wholesale_unit_occupied_spaces = @wholesale_unit_occupied_spaces.where("vehicles.sales_hold is true OR vehicles.service_hold is true")
        @sold_vehicle_spaces = @sold_vehicle_spaces.where("vehicles.sales_hold is true OR vehicles.service_hold is true")
      end

      def maybe_filter_by_no_test_drives
        return unless params.dig(:display_mode) == "no_test_drives"
        
        test_drive_vehicle_ids = Event.includes(:tag).where(event_type: "test_drive").map{|e| e.tag.vehicle_id}

        @new_vehicle_occupied_space = @new_vehicle_occupied_space.where.not(vehicles: {id: test_drive_vehicle_ids})
        @used_vehicle_occupied_space = @used_vehicle_occupied_space.where.not(vehicles: {id: test_drive_vehicle_ids})
        @sold_vehicle_spaces = @sold_vehicle_spaces.where.not(vehicles: {id: test_drive_vehicle_ids})

        @duplicate_shape_ids = @parking_spaces.includes(:tags).where(tags: {active: true}).select{|p| p.tags.length > 1 && !test_drive_vehicle_ids.include?(p.tags.pluck(:vehicle_id)) }

        @loaner_occupied_spaces = []
        @lease_return_occupied_spaces = []
        @wholesale_unit_occupied_spaces = []
      end
  end
end