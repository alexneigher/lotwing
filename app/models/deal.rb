class Deal < ApplicationRecord
  has_paper_trail
  belongs_to :dealership

  scope :included_in_counts, -> { where.not(result:'N/C') }
end
