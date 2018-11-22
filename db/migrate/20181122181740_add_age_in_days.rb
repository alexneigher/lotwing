class AddAgeInDays < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :age_in_days, :integer
  end
end
