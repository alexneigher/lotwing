class Vehicle < ApplicationRecord
  acts_as_paranoid
  has_paper_trail

  has_many :tags, dependent: :destroy
  has_many :shapes, through: :tags

  has_many :events, through: :tags, dependent: :destroy

  has_one :current_parking_tag, -> { where(active: true) }, class_name: 'Tag'

  has_one :parking_space, through: :current_parking_tag, source: :shape

  has_many :service_tickets, primary_key: :stock_number, foreign_key: :stock_number, dependent: :destroy

  has_many :open_service_tickets, -> { where(status: ["New", "In Progress"]) }, primary_key: :stock_number, foreign_key: :stock_number, class_name: 'ServiceTicket'

  belongs_to :key_board_location, optional: true

  has_one :detail_job, foreign_key: 'stock_number', primary_key: "stock_number"

  enum creation_source: [:data_feed_created, :user_created]

  enum usage_type: [:is_new, :is_used, :loaner, :lease_return, :wholesale_unit]

  scope :data_feed_deleteable, -> { where(creation_source: :data_feed_created, sales_hold: false, service_hold: false) }

  validates_uniqueness_of :stock_number

  before_save :upcase_stock_number
  before_save :titleize_make_and_model

  #for now globally purge
  after_commit do
    Rails.cache.clear
  end

  def self.missing_tags(dealership, vehicles)
    currently_parked_vehicle_ids = dealership.shapes.where(shape_type: 'parking_space').joins(:vehicle).pluck(:vehicle_id)
    active_test_drive_vehicle_ids = dealership.events.where(event_type: ['test_drive', 'fuel_vehicle'], ended_at: nil).includes(:tag).pluck(:vehicle_id)
    all_vehicles_not_on_test_drives = vehicles.reject{|v| v.id.in?(active_test_drive_vehicle_ids) }
    vehicles_missing_tags = (all_vehicles_not_on_test_drives || []).reject{|v| v.id.in?(currently_parked_vehicle_ids)}
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

  def is_currently_charging?
    most_recent_event = events.order(created_at: :desc)&.first

    return false unless most_recent_event
    return true if (most_recent_event.event_type.in?(["charge_vehicle"]) && most_recent_event.ended_at.nil?)
    return false
  end

  def map_color
    case usage_type
      when "is_new"
        "#376794"
      when "is_used"
        "#90C055"
      when "loaner"
        "#E6E570"
      when "lease_return"
        "#9A5C9D"
      when "wholesale_unit"
        "#8D8C88"
      else
        "#FF9933"
      end
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
