module WebApi
  class ShapesController < ApplicationController
    before_action :set_dealership
    before_action :set_parking_lot

    def index
      @shapes = @dealership.shapes.where.not(shape_type: 'parking_space').order(shape_type: :desc).all
      @parking_spaces = @dealership.shapes.where(shape_type: 'parking_space')

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
      @building = @dealership
                    .shapes
                    .where(
                      shape_type: 'building',
                      parking_lot: @current_parking_lot
                    )

      render json: {buildings: @building}
    end

    def landscaping
      @landscaping = @dealership
                      .shapes
                      .where(
                        shape_type: 'landscaping',
                        parking_lot: @current_parking_lot
                      )
      render json: {landscaping: @landscaping}
    end

    def parking_spaces

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

      maybe_filter_by_older_than_4_days
      maybe_filter_by_holds
      maybe_filter_by_no_test_drives
      maybe_filter_by_older_than_90_days
      maybe_filter_by_older_than_60_days
      maybe_filter_by_no_movement_14_days

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
      html = ''
      @shape = @dealership.shapes.find(params[:id])

      vehicles = @shape.vehicles.includes(:tags).where(tags: {active: true})

      vehicles.each do |vehicle|
        @vehicle = vehicle

        @events = @vehicle.events.includes(:user, :resolutions)

        dealership = current_user.dealership

        @context = "lot_view"

        html += render_to_string partial: "vehicles/show"

      end

      render inline: html
    end

    private
      def set_dealership
        @dealership = current_user.dealership
      end

      def set_parking_lot
        @current_parking_lot = (@dealership.parking_lots.find_by_name(params[:parking_lot_name]) || @dealership.primary_parking_lot)
      end

      def maybe_filter_by_older_than_4_days
        return unless params.dig(:display_mode) == "no_tag_4_days"

        @new_vehicle_occupied_space = @new_vehicle_occupied_space.includes(:tags).where(tags: {active: true}).where("tags.created_at <= ?", 4.days.ago)

        @used_vehicle_occupied_space = @used_vehicle_occupied_space.includes(:tags).where(tags: {active: true}).where("tags.created_at <= ?", 4.days.ago)
        @loaner_occupied_spaces = @loaner_occupied_spaces.includes(:tags).where(tags: {active: true}).where("tags.created_at <= ?", 4.days.ago)
        @lease_return_occupied_spaces = @lease_return_occupied_spaces.includes(:tags).where(tags: {active: true}).where("tags.created_at <= ?", 4.days.ago)
        @wholesale_unit_occupied_spaces = @wholesale_unit_occupied_spaces.includes(:tags).where(tags: {active: true}).where("tags.created_at <= ?", 4.days.ago)
        @sold_vehicle_spaces = @sold_vehicle_spaces.includes(:tags).where(tags: {active: true}).where("tags.created_at <= ?", 4.days.ago)
        @duplicate_shape_ids = @parking_spaces.includes(:tags).where(tags: {active: true}).select{|p| p.tags.length > 1 && p.tags.select{|t| t.created_at <= 4.days.ago}.any? }

        @sales_hold_spaces = []
        @service_hold_spaces = []
      end

      def maybe_filter_by_no_movement_14_days
        return unless params.dig(:display_mode) == "no_movement_14_days"

        recent_change_stall_vehicle_ids = @dealership.events.joins(:tag).where(event_type: 'change_stall').where("events.created_at >= ?", 14.days.ago).pluck(:vehicle_id)

        @new_vehicle_occupied_space = @new_vehicle_occupied_space.where.not(vehicles: {id: recent_change_stall_vehicle_ids}).where("vehicles.created_at < ?", 14.days.ago)
        @used_vehicle_occupied_space = @used_vehicle_occupied_space.where.not(vehicles: {id: recent_change_stall_vehicle_ids}).where("vehicles.created_at < ?", 14.days.ago)
        @loaner_occupied_spaces = @loaner_occupied_spaces.where.not(vehicles: {id: recent_change_stall_vehicle_ids}).where("vehicles.created_at < ?", 14.days.ago)
        @lease_return_occupied_spaces = @lease_return_occupied_spaces.where.not(vehicles: {id: recent_change_stall_vehicle_ids}).where("vehicles.created_at < ?", 14.days.ago)
        @wholesale_unit_occupied_spaces = @wholesale_unit_occupied_spaces.where.not(vehicles: {id: recent_change_stall_vehicle_ids}).where("vehicles.created_at < ?", 14.days.ago)
        @sold_vehicle_spaces = @sold_vehicle_spaces.where.not(vehicles: {id: recent_change_stall_vehicle_ids}).where("vehicles.created_at < ?", 14.days.ago)

        @duplicate_shape_ids = []
        @sales_hold_spaces = []
        @service_hold_spaces = []
      end

      #this is only for new vehicles
      def maybe_filter_by_older_than_90_days
        return unless params.dig(:display_mode) == "age_90_days_old"
        @new_vehicle_occupied_space = @new_vehicle_occupied_space.where('vehicles.age_in_days > 90')
        @sold_vehicle_spaces = []
        @duplicate_shape_ids = []
        @used_vehicle_occupied_space = []
        @loaner_occupied_spaces = []
        @lease_return_occupied_spaces = []
        @wholesale_unit_occupied_spaces = []
        @sales_hold_spaces = []
        @service_hold_spaces = []
      end

      #this is only for used vehicles
      def maybe_filter_by_older_than_60_days
        return unless params.dig(:display_mode) == "age_60_days_old"
        @used_vehicle_occupied_space = @used_vehicle_occupied_space.where('vehicles.age_in_days > 60')
        @sold_vehicle_spaces = []
        @duplicate_shape_ids = []
        @new_vehicle_occupied_space = []
        @loaner_occupied_spaces = []
        @lease_return_occupied_spaces = []
        @wholesale_unit_occupied_spaces = []
        @sales_hold_spaces = []
        @service_hold_spaces = []
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


        @loaner_occupied_spaces = @loaner_occupied_spaces.where.not(vehicles: {id: test_drive_vehicle_ids})
        @lease_return_occupied_spaces = @lease_return_occupied_spaces.where.not(vehicles: {id: test_drive_vehicle_ids})
        @wholesale_unit_occupied_spaces = @wholesale_unit_occupied_spaces.where.not(vehicles: {id: test_drive_vehicle_ids})

        @duplicate_shape_ids = @parking_spaces.includes(:tags).where(tags: {active: true}).select{|p| p.tags.length > 1 && !test_drive_vehicle_ids.include?(p.tags.pluck(:vehicle_id)) }

        @sales_hold_spaces = []
        @service_hold_spaces = []
      end
  end
end