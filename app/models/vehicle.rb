class Vehicle < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :shapes, through: :tags

  has_many :events, through: :tags, dependent: :destroy

  has_one :current_parking_tag, -> { where(active: true) }, class_name: 'Tag'

  has_one :parking_space, through: :current_parking_tag, source: :shape

  has_many :service_tickets, primary_key: :stock_number, foreign_key: :stock_number, dependent: :destroy

  has_many :open_service_tickets, -> { where(status: ["New", "In Progress"]) }, primary_key: :stock_number, foreign_key: :stock_number, class_name: 'ServiceTicket'

  belongs_to :key_board_location, optional: true

  enum creation_source: [:data_feed_created, :user_created]

  enum usage_type: [:is_new, :is_used, :loaner, :lease_return, :wholesale_unit]

  scope :data_feed_deleteable, -> { where(creation_source: :data_feed_created, sales_hold: false, service_hold: false) }

  before_save :upcase_stock_number
  before_save :titleize_make_and_model

  #for now globally purge
  after_commit do
    Rails.cache.clear
  end

  def full_description
    "#{year} #{make} #{model}"
  end

  def sold?
    sold_status.present?
  end

  def is_currently_on_test_drive?
    most_recent_event = events.order(created_at: :desc)&.first

    return false unless most_recent_event
    return true if (most_recent_event.event_type.in?(["test_drive", "fuel_vehicle"]) && most_recent_event.ended_at.nil?)
    return false
  end


  private
    def upcase_stock_number
      self.stock_number = stock_number.upcase
    end

    def titleize_make_and_model
      return unless make.present?
      self.make = make.downcase.titleize

      return unless model.present?
      self.model = model.downcase.titleize
    end
end
