class EventSerializer
  include FastJsonapi::ObjectSerializer
  extend ActionView::Helpers::DateHelper
  extend EventsHelper

  attributes :id, :event_type, :started_at, :ended_at
  belongs_to :tag

  attribute :parking_space do |event|
    event&.tag&.shape&.geo_info
  end

  attribute :summary do |event|
    "<strong> #{event.user.full_name} (#{time_ago_in_words(event.created_at)} ago) </strong><br>#{event_type_short_description(event)}"
  end
end
