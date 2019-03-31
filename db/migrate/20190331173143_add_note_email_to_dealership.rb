class AddNoteEmailToDealership < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :new_note_notification_addresses, :string
  end
end
