module EventsHelper

  def event_type_short_description(event)
    vehicle = event.tag.vehicle
    case event.event_type
      when 'test_drive'
        "Vehicle: #{vehicle.stock_number} (#{vehicle.full_description}) was taken for a test drive."
      when 'note'
        "Vehicle: #{vehicle.stock_number} (#{vehicle.full_description}) has a new note: <br> #{event.event_details}"
      when "change_stall", "tag"
        "Vehicle: #{vehicle.stock_number} (#{vehicle.full_description}) was tagged in a parking space."
      when "odometer_update"
        "The odometer on vehicle: #{vehicle.vin} (#{vehicle.full_description}) has a new reading."
      when "fuel_vehicle"
        "The vehicle: #{vehicle.vin} was taken for fuel."
    end
  end
end