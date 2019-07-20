class CreateServiceTicketNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :service_ticket_jobs do |t|
      
      t.text :note
      t.references :service_ticket, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
