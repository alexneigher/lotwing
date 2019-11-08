class Tag < ApplicationRecord
  belongs_to :shape
  belongs_to :vehicle

  has_many :events, dependent: :destroy

  # for now globally purge
  after_commit do
    Rails.cache.clear
  end 

end
