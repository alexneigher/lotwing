class ChangeDataTypeOnGoodThroughDate < ActiveRecord::Migration[5.1]
  def change
    change_column :deals, :good_through_date, :string
  end
end
