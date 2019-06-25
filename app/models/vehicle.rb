class Vehicle < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :shapes, through: :tags

  has_many :events, through: :tags, dependent: :destroy
  
  has_one :current_parking_tag, -> { where(active: true) }, class_name: 'Tag'
  
  has_one :parking_space, through: :current_parking_tag, source: :shape

  belongs_to :key_board_location, optional: true
  
  enum creation_source: [:data_feed_created, :user_created]
  
  enum usage_type: [:is_new, :is_used, :loaner, :lease_return, :wholesale_unit]

  def full_description
    "#{year} #{make} #{model}"
  end
end
