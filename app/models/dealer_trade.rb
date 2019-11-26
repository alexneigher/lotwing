class DealerTrade < ApplicationRecord
  has_paper_trail
  validate :at_least_one_sale_direction_specified

  belongs_to :vehicle, foreign_key: "stock_number", primary_key: "stock_number", optional: true

  private
    def at_least_one_sale_direction_specified
      if (your_trade == false && your_purchase == false && our_trade == false && our_purchase == false)
        errors.add(:trade_direction, "(Your Trade, Your Purchase, Our Trade, or Our Purchase) must be specified.")
      end
    end
end
