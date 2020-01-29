class ApplicationController < ActionController::Base  
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action :check_for_terms_acceptance, unless: :devise_controller? #let them log in first

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def check_for_terms_acceptance
      if current_user
        redirect_to new_service_license_agreement_path and return unless current_user.accepted_service_license_agreement?
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
    end

    # Add current user_id to lograge payload for better logging
    #https://coderwall.com/p/9x0h6a/better-rails-logging-user_id-remote_ip-with-lograge-on-heroku
    def append_info_to_payload(payload)
      super
      payload[:user_id] = current_user.present? ? current_user.id : "no user"
    end

end
