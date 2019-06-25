class KeyBoardLocation < ApplicationRecord
  
  has_many :vehicles
  belongs_to :dealership
  
end
