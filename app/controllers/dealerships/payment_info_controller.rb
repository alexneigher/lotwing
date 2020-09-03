class Dealerships::PaymentInfoController < ApplicationController

  def index
    @dealership = current_user.dealership
  end
end