class DetailJob < ApplicationRecord
  belongs_to :dealership

  has_one :sales_rep, class_name: 'User', foreign_key: :id, primary_key: 'sales_rep_id'
  has_one :detailer, class_name: 'User', foreign_key: :id, primary_key: 'detailer_id'

  has_one :vehicle, foreign_key: "stock_number", primary_key: "stock_number"

  def status
    return :not_started if started_at.nil?

    return :in_progress if started_at.present? && completed_at.nil?

    return :complete if completed_at.present?
  end
end
