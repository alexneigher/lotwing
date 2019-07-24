class AddDatetimesToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :started_at, :datetime
    add_column :events, :ended_at, :datetime 
  end
end
