class AddFiPresaleToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :f_i_pre_sell, :boolean, default: false
    add_column :deals, :f_i_pre_sell_product_list, :text
  end
end
