class CreateDailyChecklists < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_checklists do |t|
      t.references :dealership

      t.timestamps
    end
  end
end
