class Deal < ApplicationRecord
  has_paper_trail
  belongs_to :dealership
  belongs_to :vehicle, foreign_key: "stock_number", primary_key: "stock_number", optional: true

  belongs_to :sales_rep, class_name: 'User'
  belongs_to :split_rep, class_name: 'User', optional: true

  scope :included_in_counts, -> { where.not( result:'N/C' ) }

  validates_presence_of :sales_rep_id

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

    def maybe_update_vehicle
      if stored?
        vehicle&.update(sold_status: nil) #stored deals do not mark associated vehicles as sold
      else
        vehicle&.update(sold_status: "Sold to #{client_last_name}") #mark associated vehicle as sold
      end
    end
end
