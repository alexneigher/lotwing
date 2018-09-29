class CreateResolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :resolutions do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.text :details
      t.timestamps
    end
  end
end
