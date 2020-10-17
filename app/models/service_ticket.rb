class ServiceTicket < ApplicationRecord
  belongs_to :dealership

  belongs_to :created_by_user, class_name: 'User'
  belongs_to :completed_by_user, class_name: 'User', optional: true

  scope :incomplete, -> {where.not(status: 'Complete')}
  scope :complete, -> {where(status: 'Complete')}

  has_many :service_ticket_jobs, dependent: :destroy
  has_many :service_ticket_departments, dependent: :destroy

  has_one :vehicle, foreign_key: "stock_number", primary_key: "stock_number"
  accepts_nested_attributes_for :service_ticket_jobs

  after_create :maybe_update_vehicle_data

  private
    # after create try to make the vehicle more populated, only for user created vehicles
    def maybe_update_vehicle_data
      return unless vehicle&.user_created?

      vehicle.update(
        make: self.make,
        model: self.model,
        year: self.year,
        vin: self.vin,
        color: self.color,
      )
    end
end
