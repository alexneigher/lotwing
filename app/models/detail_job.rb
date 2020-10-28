class DetailJob < ApplicationRecord
  belongs_to :dealership

  has_one :sales_rep, class_name: 'User', foreign_key: :id, primary_key: 'sales_rep_id'
  has_one :detailer, class_name: 'User', foreign_key: :id, primary_key: 'detailer_id'
  has_one :most_recently_paused_by_user, class_name: 'User', foreign_key: :id, primary_key: 'most_recently_paused_by_user_id'

  has_one :vehicle, foreign_key: "stock_number", primary_key: "stock_number"

  before_save :capitalize_stock_number

  def status
    return :not_started if started_at.nil?

    return :in_progress if started_at.present? && completed_at.nil?

    return :complete if completed_at.present?
  end

  def self.sort_by_date
    <<~SQL
      CASE
        WHEN DATE(must_be_completed_by at time zone 'utc' at time zone 'america/los_angeles') = '"#{DateTime.current.in_time_zone('US/Pacific').to_date}"'
          THEN 0
        WHEN DATE(must_be_completed_by at time zone 'utc' at time zone 'america/los_angeles') > '"#{DateTime.current.in_time_zone('US/Pacific').to_date}"'
          THEN 1
      END
    SQL
  end

  def self.sort_by_status
    <<~SQL
      CASE
        WHEN started_at is not null and completed_at is null
          THEN 0

        WHEN started_at is null and completed_at is null
          THEN 2

        WHEN completed_at is not null
          THEN 3
      END
    SQL

  end

  private
    def capitalize_stock_number
      return unless stock_number.present?

      self.stock_number = stock_number.upcase
    end
end
