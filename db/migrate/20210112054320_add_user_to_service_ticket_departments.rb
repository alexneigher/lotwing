class AddUserToServiceTicketDepartments < ActiveRecord::Migration[5.1]
  def change
    add_reference :service_ticket_departments, :completed_by_user
    add_reference :service_ticket_departments, :in_progress_by_user

    add_column :service_ticket_departments, :completed_at, :datetime
    add_column :service_ticket_departments, :marked_in_progress_at, :datetime
  end
end
