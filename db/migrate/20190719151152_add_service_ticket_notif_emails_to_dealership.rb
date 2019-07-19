class AddServiceTicketNotifEmailsToDealership < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :new_service_ticket_notification_addresses, :string
  end
end
