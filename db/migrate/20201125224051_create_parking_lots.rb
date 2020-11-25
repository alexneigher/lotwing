class CreateParkingLots < ActiveRecord::Migration[5.1]
  def change
    create_table :parking_lots do |t|
      t.references :dealership, foreign_key: true
      t.boolean :is_primary_lot, default: false
      t.string :name
      t.string :initials
      t.timestamps
    end
  end
end
