class CreateChecklistItems < ActiveRecord::Migration[5.1]
  def change
    create_table :checklist_items do |t|
      t.datetime :completed_at
      t.references :completed_by_user
      t.string :title
      t.string :item_tier
      t.references :daily_checklist

      t.timestamps
    end
  end
end
