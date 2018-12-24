class CreateCheckRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :check_requests do |t|
      t.boolean :is_check
      t.boolean :is_cash
      t.string :request_by
      t.string :department
      t.string :amount_requested
      t.string :stock_number
      t.string :make
      t.string :model
      t.text :payable_to
      t.text :description
      t.references :dealership

      t.string :request_date

      t.timestamps
    end
  end
end
