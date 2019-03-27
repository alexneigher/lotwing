class ChangeRebateAndBulletin < ActiveRecord::Migration[5.1]
  def change
    change_column :deals, :rebates, :text
    change_column :deals, :bulletin_number, :text
  end
end
