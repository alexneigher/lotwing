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

  has_one :data_sync
  accepts_nested_attributes_for :data_sync

  after_create :create_data_sync


  private
    def create_data_sync
      self.create_data_sync
    end
end
