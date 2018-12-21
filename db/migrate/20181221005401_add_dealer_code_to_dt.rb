class AddDealerCodeToDt < ActiveRecord::Migration[5.1]
  def change
    add_column :dealer_trades, :dealer_code, :string
    add_column :suggested_trade_dealerships, :dealer_code, :string

  end
end
