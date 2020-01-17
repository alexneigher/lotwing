class Home::UserActivityController < ApplicationController

  def index
    all_events = current_user.dealership.events

    user_events = all_events.group(:user).count

    @role_grouped_user_events = user_events.group_by{|u, v| u.permission_level}
  end

end