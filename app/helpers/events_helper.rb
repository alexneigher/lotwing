module EventsHelper

  def event_type_short_description(event)
    vehicle = event.tag.vehicle
    case event.event_type
      when 'test_drive'
        "Vehicle: #{vehicle.vin} (#{vehicle.full_description}) was taken for a test drive."
      when 'tag'
        "Vehicle: #{vehicle.vin} (#{vehicle.full_description}) was tagged in its current parking spot."
    end
  end
end