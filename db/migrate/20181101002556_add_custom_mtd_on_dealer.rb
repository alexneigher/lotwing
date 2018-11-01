class AddCustomMtdOnDealer < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :custom_mtd_start_date, :date
  end
end
