class DealerTrade < ApplicationRecord
  has_paper_trail

  belongs_to :vehicle, foreign_key: "stock_number", primary_key: "stock_number", optional: true
end
