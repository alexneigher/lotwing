class CreateKeyBoardLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :key_board_locations do |t|
      t.string :name
      t.references :dealership
      t.timestamps
    end
  end
end
