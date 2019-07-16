class CreateServiceTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :service_tickets do |t|

      t.references :dealership
      t.references :created_by_user
      t.references :completed_by_user

      t.string :stock_number
      t.string :vin
      t.string :mileage
      t.string :year
      t.string :make
      t.string :model
      t.string :color

      t.string :status

      t.datetime :complete_by_datetime

      t.timestamps

    end
  end
end
