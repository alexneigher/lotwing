class CreateEmailPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :email_preferences do |t|
      t.references :user
      t.boolean :note_email
      t.boolean :service_ticket_email
      t.boolean :duplicate_stock_number_email

      t.timestamps
    end
  end
end
