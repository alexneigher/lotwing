class AddStoredToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :stored, :boolean, default: false
  end
end
