class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :user
      t.references :tag
      t.integer :event_type, default: 0
      t.text :event_details
      t.boolean :acknowledged, default: false

      t.timestamps
    end
  end
end
