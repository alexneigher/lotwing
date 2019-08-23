class AddTimeOpenToServiceTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :service_tickets, :completed_at, :datetime
  end
end
