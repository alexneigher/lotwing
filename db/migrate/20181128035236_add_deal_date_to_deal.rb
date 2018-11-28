class AddDealDateToDeal < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :deal_date, :date
  end
end
