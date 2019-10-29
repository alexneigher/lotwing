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


      @new_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "is_new"})
      @used_vehicle_occupied_space = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "is_used"})
      
      @loaner_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "loaner"})
      @lease_return_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "lease_return"})
      @wholesale_unit_occupied_spaces = @parking_spaces.joins(:vehicle).where(vehicles: {usage_type: "wholesale_unit"})

      @duplicate_shape_ids = @parking_spaces.includes(:tags).where(tags: {active: true}).select{|p| p.tags.length > 1}

      maybe_filter_by_older_than_4_days
      maybe_filter_by_no_test_drives

      @empty_parking_space = @parking_spaces - [@new_vehicle_occupied_space + @used_vehicle_occupied_space + @loaner_occupied_spaces + @lease_return_occupied_spaces +@wholesale_unit_occupied_spaces].flatten

      render json: {
                    new_vehicle_occupied_spaces: @new_vehicle_occupied_space,
                    used_vehicle_occupied_spaces: @used_vehicle_occupied_space,
                    loaner_occupied_spaces: @loaner_occupied_spaces,
                    lease_return_occupied_spaces: @lease_return_occupied_spaces,
                    wholesale_unit_occupied_spaces: @wholesale_unit_occupied_spaces, 
                    empty_parking_spaces: @empty_parking_space,
                    duplicate_parked_spaces: @duplicate_shape_ids
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
        @duplicate_shape_ids = @parking_spaces.includes(:tags).where('shapes.most_recently_tagged_at < ?', 4.days.ago).where(tags: {active: true}).select{|p| p.tags.length > 1}
      end

      def maybe_filter_by_no_test_drives
        return unless params.dig(:display_mode) == "no_test_drives"
        
        test_drive_shape_ids = Event.includes(:tag).where(event_type: "test_drive").map{|e| e.tag.shape_id}
        
        @new_vehicle_occupied_space = @new_vehicle_occupied_space.where.not(id: test_drive_shape_ids)
        @used_vehicle_occupied_space = @used_vehicle_occupied_space.where.not(id: test_drive_shape_ids)
        @duplicate_shape_ids = []

        @loaner_occupied_spaces = []
        @lease_return_occupied_spaces = []
        @wholesale_unit_occupied_spaces = []
      end
  end
end