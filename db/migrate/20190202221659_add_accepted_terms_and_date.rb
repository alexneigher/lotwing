class AddAcceptedTermsAndDate < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :accepted_service_license_agreement, :boolean, default: false
    add_column :users, :accepted_service_license_agreement_datetime, :datetime
  end
end
