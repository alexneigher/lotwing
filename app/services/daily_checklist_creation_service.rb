class DailyChecklistCreationService

  def initialize(dealership_id)
    @dealership_id = dealership_id
  end

  def perform!
    ActiveRecord::Base.transaction do
      # create new checklist
      checklist = dealership.daily_checklists.create!

      # add all appropriate checklist items based on

      # "required, mandatory items"
      create_red_level_items(checklist)


      # optional dealership configurable items
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
    end

    def dealership
      @dealership ||= Dealership.find(@dealership_id)
    end
end