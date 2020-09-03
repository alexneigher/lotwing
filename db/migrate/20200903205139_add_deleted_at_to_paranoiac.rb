class AddDeletedAtToParanoiac < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :deleted_at, :datetime
    add_column :deals, :deleted_at, :datetime
    add_index :vehicles, :deleted_at
    add_index :deals, :deleted_at
  end
end
