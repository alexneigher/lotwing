class DealerTrade < ApplicationRecord
  has_paper_trail
  validate :at_least_one_sale_direction_specified

  belongs_to :vehicle, foreign_key: "stock_number", primary_key: "stock_number", optional: true

  after_save :maybe_update_vehicle

  private
    def at_least_one_sale_direction_specified
      if (your_trade == false && your_purchase == false && our_trade == false && our_purchase == false)
        errors.add(:trade_direction, "(Your Trade, Your Purchase, Our Trade, or Our Purchase) must be specified.")
      end
    end

    def maybe_update_vehicle
       #we edited the vehicle associated with this dealer trade, take the old vehicle and mark it as not sold and release any holds on it
      if saved_change_to_stock_number && saved_change_to_stock_number&.compact&.length > 1
        v = Vehicle.find_by(stock_number: saved_change_to_stock_number[0])
        v&.update(sales_hold: false, sales_hold_notes: nil)
      end
    end
end
