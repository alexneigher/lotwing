class Api::BaseController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  
  include ExceptionHandler
  include Response

  private

    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end

    # Add current user_id to lograge payload for better logging
    #https://coderwall.com/p/9x0h6a/better-rails-logging-user_id-remote_ip-with-lograge-on-heroku
    def append_info_to_payload(payload)
      super
      payload[:user_id] = current_user.present? ? current_user.id : "no user"
    end

end