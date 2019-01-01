class Deal < ApplicationRecord
  has_paper_trail
  belongs_to :dealership
  belongs_to :vehicle, foreign_key: "stock_number", primary_key: "stock_number", optional: true

  scope :included_in_counts, -> { where.not(result:'N/C') }
end
