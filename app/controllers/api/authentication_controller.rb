module Api
  class AuthenticationController < Api::BaseController
    skip_before_action :authenticate_request, only: [:login]

    #finds the user, and gives a JWT back to the client
    def login
      authenticate params[:email], params[:password]
    end

    def test
      render json: {
        message: "Correct Authentication",
        user_info: {
          full_name: current_user.full_name,
          dealership_name: current_user.dealership.name
        }
      }
    end


    private
      def authenticate(email, password)
        command = AuthenticateUser.call(email, password)

        if command.success?
          render json: {
            access_token: command.result,
            message: 'Login Successful'
          }
        else
          render json: { error: command.errors }, status: :unauthorized
        end
      end
  end
end


# {
#   "access_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NDMxMzQ1OTF9.XYiWluSEWc-QcFgAYXaw9eAOumtoh2TzzQxeyyll-uY",
#   "message": "Login Successful"
# }