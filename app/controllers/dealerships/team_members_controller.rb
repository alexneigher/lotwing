class Dealerships::TeamMembersController < ApplicationController

  def index
    @dealership = current_user.dealership
  end
end