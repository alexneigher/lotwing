class CreateServiceTicketDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :service_ticket_departments do |t|
      t.string :name
      t.references :service_ticket, foreign_key: true
      t.boolean :is_complete, default: false
      t.boolean :is_in_progress, default: false

      t.timestamps
    end
  end
end
