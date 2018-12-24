class CheckRequestsController < ApplicationController

  def index
    @check_requests = current_user.dealership.check_requests
  end

  def new
    @check_request = current_user.dealership.check_requests.new
  end

  def create
  end

end
