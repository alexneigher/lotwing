module EventsHelper

  def event_type_short_description(event)
    vehicle = event.tag.vehicle
    case event.event_type
      when 'test_drive'
        "Vehicle: #{vehicle.stock_number} (#{vehicle.full_description}) was taken for a test drive."
      when 'note'
        "Vehicle: #{vehicle.stock_number} (#{vehicle.full_description}) has a new note: <br> #{event.event_details}"
      when 'tag', "change_stall"
        "Vehicle: #{vehicle.stock_number} (#{vehicle.full_description}) moved to a new parking spot."
      when "odometer_update"
        "The odometer on vehicle: #{vehicle.vin} (#{vehicle.full_description}) has a new reading."
    end
  end
end