class ServiceTicket < ApplicationRecord
  belongs_to :dealership

  belongs_to :created_by_user, class_name: 'User'
  belongs_to :completed_by_user, class_name: 'User', optional: true

  scope :incomplete, -> {where.not(status: 'Complete')}
  scope :complete, -> {where(status: 'Complete')}

  has_many :service_ticket_jobs, dependent: :destroy

  accepts_nested_attributes_for :service_ticket_jobs

  after_create :notify_dealership

  private
    def notify_dealership
      ServiceTicketMailer.notify_about_service_ticket_created(self)
    end


end
