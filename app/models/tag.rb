class Tag < ApplicationRecord
  belongs_to :shape
  belongs_to :vehicle

  has_many :events
end
