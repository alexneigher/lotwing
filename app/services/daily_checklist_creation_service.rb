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
      create_red_level_items(checklist)

      # do yellow level items, they are all optionally configured



    end

  end


  private

    def create_red_level_items(checklist)
      # first do notes left on vehicles
      notes = dealership.events.where(event_type: "note", acknowledged: :false)
      if notes.any?
        checklist.checklist_items.create(
          item_tier: :red,
          title: "You have #{ActionController::Base.helpers.pluralize(notes.count, 'vehicle')} with notes that have not been cleared- check map, click on vehicle and resolve note (write service ticket if necessary)"
        )
      end

      # then do lost vehicles
      lost_vehicles = Vehicle.missing_tags(dealership, dealership.vehicles)
      if lost_vehicles.any?
        checklist.checklist_items.create(
          item_tier: :red,
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
            item_tier: :red,
            title: "You have #{ActionController::Base.helpers.pluralize(vehicles.count, 'stock vehicle')} on test drives for more than #{ActionController::Base.helpers.pluralize(checklist.test_drive_check_duration, 'day')}."
          )
        end
      end

    end

    def create_yellow_level_items(checklist)

    end

    def dealership
      @dealership ||= Dealership.find(@dealership_id)
    end
end