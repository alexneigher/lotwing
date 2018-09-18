class EventSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :event_type
  belongs_to :tag

  attribute :parking_space do |event|
    event.tag.shape.geo_info
  end
end
