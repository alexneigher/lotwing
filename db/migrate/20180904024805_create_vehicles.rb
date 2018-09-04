class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :vin
      t.string :make
      t.string :model
      t.string :year
      t.string :color
      t.integer :mileage
      t.references :dealership
      
      t.timestamps
    end
  end
end
