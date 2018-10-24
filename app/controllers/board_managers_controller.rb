class BoardManagersController < ApplicationController

  def show
    @deals = current_user.dealership.deals.all
  end
end