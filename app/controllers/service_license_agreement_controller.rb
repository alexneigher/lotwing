class ServiceLicenseAgreementController < ApplicationController
  skip_before_action :check_for_terms_acceptance

  def new

  end

  def create
    @user = current_user
    @user.update(accepted_service_license_agreement: true, accepted_service_license_agreement_datetime: DateTime.current)
    redirect_to root_path
  end
end