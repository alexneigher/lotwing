class AddFieldsToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :deal_notes, :text
    add_column :deals, :missing_stips_1, :string
    add_column :deals, :missing_stips_2, :string 
    add_column :deals, :certified_pre_owned, :boolean, default: false
  end
end
