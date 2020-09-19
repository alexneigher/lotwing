class DetailJob < ApplicationRecord
  belongs_to :dealership

  has_one :sales_rep, class_name: 'User', foreign_key: :id, primary_key: 'sales_rep_id'
  has_one :detailer, class_name: 'User', foreign_key: :id, primary_key: 'detailer_id'
end
