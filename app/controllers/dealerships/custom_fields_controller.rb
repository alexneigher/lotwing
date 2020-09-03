class Dealerships::CustomFieldsController < ApplicationController

  def index
    @dealership = current_user.dealership
  end
end