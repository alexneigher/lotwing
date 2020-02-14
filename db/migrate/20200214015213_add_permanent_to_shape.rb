class AddPermanentToShape < ActiveRecord::Migration[5.1]
  def change
    add_column :shapes, :temporary, :boolean, default: false
  end
end
