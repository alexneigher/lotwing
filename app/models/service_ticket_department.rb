class ServiceTicketDepartment < ApplicationRecord
  belongs_to :service_ticket

  after_update :maybe_update_ticket_status

  after_create :notify_users

  ALL_DEPARTMENTS = ["service_department", "collision_department", "parts_department"]

  def formatted_name
    name.split("_").first.titleize + " Dept."
  end

  private
    def notify_users
      ServiceTicketMailer.notify_about_service_ticket_created(self)
    end

    def maybe_update_ticket_status
      all_complete = service_ticket.service_ticket_departments.all?{|d| d.is_complete? }
      any_in_progress = service_ticket.service_ticket_departments.any?{|d| d.is_in_progress? }

      # all are complete, so update status and set completed at
      if all_complete
        service_ticket.update( completed_at: DateTime.current, status: 'Complete' )

      elsif any_in_progress
        # if any are in progress, mark ticket in progress
        service_ticket.update(status: "In Progress", completed_at: nil)

      else
        service_ticket.update(status: 'New', completed_at: nil)
      end

    end

end
