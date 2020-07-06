class DropOldEmailFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :dealerships, :new_note_notification_addresses
    remove_column :dealerships, :new_service_ticket_notification_addresses
  end
end
