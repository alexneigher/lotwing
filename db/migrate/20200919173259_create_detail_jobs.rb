class CreateDetailJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :detail_jobs do |t|
      t.string :stock_number
      t.string :make
      t.string :model
      t.string :color
      t.string :year
      t.string :vin
      t.datetime :started_at
      t.datetime :completed_at
      t.datetime :must_be_completed_by

      t.bigint :sales_rep_id
      t.bigint :detailer_id

      t.references :dealership

      t.string :jobs #tmp refactor this

      t.timestamps
    end
  end
end
