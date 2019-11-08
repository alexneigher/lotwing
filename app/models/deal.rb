class Deal < ApplicationRecord
  has_paper_trail
  belongs_to :dealership
  belongs_to :vehicle, foreign_key: "stock_number", primary_key: "stock_number", optional: true

  scope :included_in_counts, -> { where.not( result:'N/C' ) }

  validates_presence_of :sales_rep

  after_save :maybe_update_vehicle



  private
    def maybe_update_vehicle
      if stored?
        vehicle&.update(sold_status: nil) #stored deals do not mark associated vehicles as sold
      else
        vehicle&.update(sold_status: "Sold to #{client_last_name}") #mark associated vehicle as sold
      end
    end
end
