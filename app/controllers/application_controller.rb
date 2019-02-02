class ApplicationController < ActionController::Base  
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  #before_action :check_for_terms_acceptance, unless: :devise_controller? #let them log in first

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    # def check_for_terms_acceptance
    #   redirect_to new_service_license_agreement_path and return unless current_user.accepted_service_license_agreement?
    # end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
    end

end
