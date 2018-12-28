class AddBankAndmenuToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :bank_name, :string
    add_column :deals, :menu_number, :string
  end
end
