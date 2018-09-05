class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.references :vehicle
      t.references :shape

      t.boolean :active, default: true
      t.timestamps
    end
  end
end
