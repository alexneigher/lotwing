class ServiceTicket < ApplicationRecord
  belongs_to :dealership

  belongs_to :created_by_user, class_name: 'User'
  belongs_to :completed_by_user, class_name: 'User', optional: true

  scope :incomplete, -> {where.not(status: 'Complete')}
  scope :complete, -> {where(status: 'Complete')}

  has_many :service_ticket_jobs, dependent: :destroy

  has_one :vehicle, foreign_key: "stock_number", primary_key: "stock_number"
  accepts_nested_attributes_for :service_ticket_jobs

  after_create :notify_dealership

  after_update :maybe_persist_completed_time

  private
    def notify_dealership
      ServiceTicketMailer.notify_about_service_ticket_created(self)
    end

    def maybe_persist_completed_time
      if self.saved_change_to_status? && self.status == "Complete"
        # we just changes the status to complete, set the time
        self.update( completed_at: DateTime.current )
      end
    end


end
