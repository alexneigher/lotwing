module Api
  class DealsController < Api::BaseController

    def index
      @deals = current_user.dealership.deals.all
      json_response(@deals)
    end

  end
end