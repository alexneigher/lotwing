class Dealership < ApplicationRecord
  has_many :users

  has_many :events, through: :users

  has_many :shapes
  has_many :vehicles

  has_many :key_board_locations

  has_many :deals
  has_many :dealer_trades
  has_many :suggested_trade_dealerships
  has_many :check_requests
  has_many :service_tickets
  has_many :detail_jobs

  has_one :dealership_configuration

  has_one :data_sync
  accepts_nested_attributes_for :data_sync

  has_many :daily_checklists
  has_one :current_daily_checklist, -> { where("DATE(created_at at time zone 'utc' at time zone 'US/Pacific') = ?", Time.current.in_time_zone("US/Pacific").to_date ) }, class_name: 'DailyChecklist'

  after_create :create_data_sync
  after_create :add_dealership_configuration

  def in_good_financial_standing?
    stripe_customer_id.present? &&
    stripe_subscription_id.present? &&
    most_recent_payment_received_at >= Date.today.beginning_of_month
  end

  private
    def create_data_sync
      self.create_data_sync
    end

    def add_dealership_configuration
      self.create_dealership_configuration
    end
end

