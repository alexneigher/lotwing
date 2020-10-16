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
    #after create try to make the vehicle more populated

    def maybe_update_vehicle_data
      return unless vehicle

      vehicle.update(
        make: (vehicle.make.presence || self.make),
        model: (vehicle.model.presence || self.model),
        year: (vehicle.year.presence || self.year),
        vin: (vehicle.vin.presence || self.vin),
        color: (vehicle.color.presence || self.color),
      )
    end
end
