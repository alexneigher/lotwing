class CreateShapes < ActiveRecord::Migration[5.1]
  def change
    create_table :shapes do |t|
      t.json :geo_info

      t.timestamps
    end
  end
end
