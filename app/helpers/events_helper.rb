module EventsHelper

  def event_type_short_description(event)
    vehicle = event.tag.vehicle
    case event.event_type
      when 'test_drive'
        "Vehicle was taken for a test drive. #{event.event_details}"
      when 'note'
        "Vehicle has a new note: #{event.event_details}"
      when "change_stall", "tag"
        "Vehicle was tagged in a parking space."
      when "odometer_update"
        "Vehicle has a new odometer reading. (#{event.event_details})"
      when "fuel_vehicle"
        "Vehicle was taken for fuel."
    end
  end
end