class Deal < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :dealership
  belongs_to :vehicle, foreign_key: "stock_number", primary_key: "stock_number", optional: true

  belongs_to :sales_rep, class_name: 'User'
  belongs_to :split_rep, class_name: 'User', optional: true

  scope :included_in_counts, -> { where.not( result:'N/C' ) }

  validates_presence_of :sales_rep_id

  before_save :upcase_stock_number
  after_save :maybe_update_vehicle

  def self.order_by_rep_ids(ids, rep_id_type)
    order_by = ["CASE"]
    ids.each_with_index do |id, index|
      order_by << "WHEN #{rep_id_type}='#{id}' THEN #{index}"
    end
    order_by << "END"
    order(order_by.join(" "))
  end

  private

    def upcase_stock_number
      self.stock_number = stock_number.upcase
    end

    def maybe_update_vehicle
      #we edited the vehicle associated with this deal, take the old vehicle and mark it as not sold and release any holds on it
      if saved_change_to_stock_number && saved_change_to_stock_number&.compact&.length > 1
        v = Vehicle.find_by(stock_number: saved_change_to_stock_number[0])
        v&.update(sold_status: nil, sales_hold: false, sales_hold_notes: nil)
      end

      #edit current vehicle status
      if stored?
        vehicle&.update(sold_status: nil) #stored deals do not mark associated vehicles as sold
      else
        vehicle&.update(sold_status: "Sold to #{client_last_name}") #mark associated vehicle as sold
      end
    end
end
