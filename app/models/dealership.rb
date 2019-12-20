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

  has_one :data_sync
  accepts_nested_attributes_for :data_sync

  after_create :create_data_sync

  def in_good_financial_standing?
    false
    # stripe_customer_id.present? &&
    # stripe_subscription_present? &&
    # most_recent_payment_created_at >= date.today.beginning_of_month
  end

  private
    def create_data_sync
      self.create_data_sync
    end
end
