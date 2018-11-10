module Dealerships
  class UsersController < ApplicationController
    
    def new
    end

    def create
      @dealership = current_user.dealership

      random_token = SecureRandom.urlsafe_base64
      random_password = SecureRandom.urlsafe_base64

      @dealership
        .users
        .create!(user_params.merge({reset_password_token: random_token, password: random_password}))

      #TODO send them an email with an invitation
      redirect_to edit_dealership_path(@dealership)
    end


    private
      def user_params
        params.require(:user).permit(:email, :full_name)
      end
  end
end