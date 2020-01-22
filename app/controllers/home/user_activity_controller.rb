class Home::UserActivityController < ApplicationController

  def index
    hash = {}

    @event_type = params[:event_type].presence

    event_type_hash = @event_type ? {event_type: @event_type}:{}

    all_dealership_users = current_user.dealership.users

    grouped_by_user_events = current_user
                              .dealership
                              .events
                              .where(event_type_hash)
                              .where("events.created_at >= ?", DateTime.current.in_time_zone("US/Pacific").beginning_of_month)
                              .group_by(&:user_id)

    grouped_by_user_events.each do |user_id, events|
      last_day_events = events.select{|e| e.created_at.in_time_zone("US/Pacific") >= DateTime.current.in_time_zone("US/Pacific").beginning_of_day}.count
      last_week_events = events.select{ |e| e.created_at.in_time_zone("US/Pacific") >= 1.week.ago.in_time_zone("US/Pacific").beginning_of_day}.count
      mtd_events = events.select{|e| e.created_at.in_time_zone("US/Pacific") >= DateTime.current.in_time_zone("US/Pacific").beginning_of_month}.count

      user = all_dealership_users.detect{|u| u.id == user_id }

      hash[user] = {"1" => last_day_events, "7" => last_week_events, "mtd" => mtd_events}
    end

    remaining_users = all_dealership_users - hash.keys

    remaining_users.each do |u|
      hash[u] = {"1" => 0, "7" => 0, "mtd" => 0}
    end
    
    @role_grouped_user_events = hash.group_by{ |u, event_counts| u.permission_level }
  end

end