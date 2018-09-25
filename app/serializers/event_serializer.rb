class EventSerializer
  include FastJsonapi::ObjectSerializer
  extend ActionView::Helpers::DateHelper
  extend EventsHelper

  attributes :id, :event_type
  belongs_to :tag

  attribute :parking_space do |event|
    event.tag.shape.geo_info
  end

  attribute :summary do |event|
    "<strong> #{time_ago_in_words(event.created_at)} ago </strong> #{event.user.full_name}: #{event_type_short_description(event)}"
  end
end
