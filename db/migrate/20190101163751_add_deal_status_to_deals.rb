class AddDealStatusToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :deal_status, :string
  end
end
