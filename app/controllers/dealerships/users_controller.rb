module Dealerships
  class UsersController < ApplicationController

    def new
    end

    def create
      @dealership = current_user.dealership

      random_token = SecureRandom.urlsafe_base64
      random_password = SecureRandom.urlsafe_base64

      @user = @dealership
        .users
        .create!(user_params.merge({reset_password_token: random_token, password: random_password}))

      UserMailer.send_signup_email(@user).deliver

      redirect_to edit_dealership_path(@dealership)
    end

    def show
      @dealership = current_user.dealership
      @user = @dealership.users.find(params[:id])
    end

    def update
      @dealership = current_user.dealership
      @user = @dealership.users.find(params[:id])

      @user.update(user_params)

      redirect_to edit_dealership_path(@dealership)
    end

    def edit
      @dealership = current_user.dealership
      @user = @dealership.users.find(params[:id])
    end

    def destroy
      @dealership = current_user.dealership
      @user = @dealership.users.find(params[:id])

      @user.update(status: :deactivated)

      redirect_to edit_dealership_path(@dealership)
    end

    private
      def user_params
        params.require(:user).permit(:email, :full_name, :permission_level, :status, special_permissions: [], email_preference_attributes:[:id, :note_email, :duplicate_stock_number_email, :service_department_email, :collision_department_email, :parts_department_email] )
      end
  end
end