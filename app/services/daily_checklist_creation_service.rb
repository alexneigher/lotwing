class DailyChecklistCreationService

  def initialize(dealership_id)
    @dealership_id = dealership_id
  end

  def perform!
    ActiveRecord::Base.transaction do
      # create new checklist
      checklist = dealership.daily_checklists.create!

      # add all appropriate checklist items based on

      # do red level items, 2 are required, one is optionally configured
      create_sales_manager_red_level_items(checklist)

      # do yellow level items, they are all optionally configured
      create_sales_manager_yellow_level_items(checklist)

      #do yellow level service manager items
      create_service_manager_yellow_level_items(checklist)
    end

  end


  private

    def create_sales_manager_red_level_items(checklist)
      # first do notes left on vehicles
      notes = dealership.events.where(event_type: "note", acknowledged: :false)
      if notes.any?
        checklist.checklist_items.create(
          item_tier: :sales_manager_red,
          title: "You have #{ActionController::Base.helpers.pluralize(notes.count, 'vehicle')} with notes that have not been cleared- check map, click on vehicle and resolve note (write service ticket if necessary)"
        )
      end

      # then do lost vehicles
      lost_vehicles = Vehicle.missing_tags(dealership, dealership.vehicles)
      if lost_vehicles.any?
        checklist.checklist_items.create(
          item_tier: :sales_manager_red,
          title: "You have #{ActionController::Base.helpers.pluralize(lost_vehicles.count, 'lost vehicle')}. Find #{ActionController::Base.helpers.pluralize(lost_vehicles.count, 'vehicle')} and tag."
        )
      end

      #if the dealership has configured it, check for test drives lasting longer than xx days
      if checklist.should_check_for_test_drives?
        vehicles = dealership
                    .vehicles
                    .where(usage_type: ["is_new", "is_used", "lease_return", "wholesale_unit"])
                    .joins(:events)
                    .where
                    .not(events: {started_at: nil})
                    .where(events: {ended_at: nil})
                    .where(events: {event_type: ["test_drive", "fuel_vehicle"]})
                    .where("DATE(events.created_at) <= ?", checklist.test_drive_check_duration.days.ago)

        if vehicles.any?
          checklist.checklist_items.create(
            item_tier: :sales_manager_red,
            title: "You have #{ActionController::Base.helpers.pluralize(vehicles.count, 'stock vehicle')} on test drives for more than #{ActionController::Base.helpers.pluralize(checklist.test_drive_check_duration, 'day')}."
          )
        end
      end

    end

    def create_sales_manager_yellow_level_items(checklist)
      # first check to see if the used UCV checks are defined
      if checklist.should_check_for_used_ucv?
        vehicles = dealership
                    .vehicles
                    .where(usage_type: 'is_used')
                    .where(creation_source: :user_created)
                    .where("DATE(vehicles.created_at) <= ?", checklist.used_ucv_check_duration.days.ago)
        if vehicles.any?
          checklist.checklist_items.create(
            item_tier: :sales_manager_yellow,
            title: "You have #{ActionController::Base.helpers.pluralize(vehicles.count, 'used UCV')} older than #{ActionController::Base.helpers.pluralize(checklist.used_ucv_check_duration, 'day')}."
          )
        end
      end

      # then check to see if the New UCV checks are defined
      if checklist.should_check_for_new_ucv?
        vehicles = dealership
                    .vehicles
                    .where(usage_type: 'is_new')
                    .where(creation_source: :user_created)
                    .where("DATE(vehicles.created_at) <= ?", checklist.new_ucv_check_duration.days.ago)
        if vehicles.any?
          checklist.checklist_items.create(
            item_tier: :sales_manager_yellow,
            title: "You have #{ActionController::Base.helpers.pluralize(vehicles.count, 'new UCV')} older than #{ActionController::Base.helpers.pluralize(checklist.new_ucv_check_duration, 'day')}."
          )
        end
      end

      # check to see if there are any custom events
      if checklist.sales_manager_custom_items.any?
        checklist.sales_manager_custom_items.each do |item|
          next if item.blank?
          checklist.checklist_items.create(
            item_tier: :sales_manager_yellow,
            title: item
          )
        end
      end

    end


    def create_service_manager_yellow_level_items(checklist)
      if checklist.should_check_for_service_loaner?
        vehicles = dealership
                    .vehicles
                    .where(usage_type: "loaner")
                    .joins(:events)
                    .where
                    .not(events: {started_at: nil})
                    .where(events: {ended_at: nil})
                    .where(events: {event_type: ["test_drive", "fuel_vehicle"]})
                    .where("DATE(events.created_at) <= ?", checklist.service_loaner_duration.days.ago)

        if vehicles.any?
          checklist.checklist_items.create(
            item_tier: :service_manager_yellow,
            title: "You have #{ActionController::Base.helpers.pluralize(vehicles.count, 'service loaner')} out for more than #{ActionController::Base.helpers.pluralize(checklist.service_loaner_duration, 'day')}."
          )
        end
      end

      # check to see if there are any custom events
      if checklist.service_manager_custom_items.any?
        checklist.service_manager_custom_items.each do |item|
          next if item.blank?
          checklist.checklist_items.create(
            item_tier: :service_manager_yellow,
            title: item
          )
        end
      end
    end

    def dealership
      @dealership ||= Dealership.find(@dealership_id)
    end
end