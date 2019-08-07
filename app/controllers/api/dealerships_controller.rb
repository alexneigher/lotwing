module Api
  class DealershipsController < Api::BaseController
    
    def show
      dealership = current_user.dealership
      json_response(dealership)
    end

  end
end