module Api
  class DealershipsController < Api::BaseController
    
    def show
      dealership = current_user.dealership
      render json: {
                    dealership: dealership,
                    users: dealership.users
                  }
    end

  end
end