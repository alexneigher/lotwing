class Deal < ApplicationRecord
  has_paper_trail
  belongs_to :dealership
end
